// https://cloud.google.com/cloud-build/docs/configure-third-party-notifications

const IncomingWebhook = require('@slack/client').IncomingWebhook;
const config = require('./config.json');
const projects = require('./projects.json');

// QUEUED, WORKING, SUCCESS, FAILURE, INTERNAL_ERROR, TIMEOUT, CANCELLED
const successStatus = ['SUCCESS'];
const failStatus = ['FAILURE', 'INTERNAL_ERROR', 'TIMEOUT'];
const finishStatus = successStatus.concat(failStatus);

const shoudSendToProjectChannel = (build) => {
  const branch = build.source.repoSource.branchName;
  return failStatus.indexOf(build.status) !== -1 ||
    (
      finishStatus.indexOf(build.status) !== -1 &&
      branch !== 'dev' &&
      !branch.startsWith('feature/')
    );
};

const shoudSendToBuildsChannel = (build) => {
  const branch = build.source.repoSource.branchName;
  return failStatus.indexOf(build.status) !== -1;
};

const shouldSendToPerson = (build) => {
  const branch = build.source.repoSource.branchName;
  return failStatus.indexOf(build.status) !== -1;
};

const shortName = (repoName) => {
  if (repoName.startsWith('github-')) {
    return repoName.split('-').slice(2).join('-');
  }
  if (repoName.startsWith('github_')) {
    return repoName.split('_').slice(2).join('_');
  }
  return repoName;
};

// subscribe is the main function called by Cloud Functions.
module.exports.subscribe = (event, callback) => {
  const build = eventToBuild(event.data.data);
  const buildsChannel = config.BUILDS_CHANNEL;
  const shortRepoName = shortName(build.source.repoSource.repoName);
  const project = projects[build.source.repoSource.repoName] ||
    projects[shortRepoName];

  console.log(`Repository: ${build.source.repoSource.repoName}`);

  // If project channel has not been configured, we determine customer name
  // from the repository name and try to use it as a channel name.
  const projectChannels = project && project.slackChannel
    ? [ project.slackChannel ]
    : [ shortRepoName, shortRepoName.split('-')[0] ];

  // Send message to the project channels
  if (shoudSendToProjectChannel(build)) {
    projectChannels.each(projectChannel => {
      console.log(`Sending message to project channel: ${projectChannel}`);
      const message = createSlackMessage(build, projectChannel, project);
      new IncomingWebhook(config.SLACK_WEBHOOK_URL).send(message);
    });
  }

  // Send message to the person who broke the build
  if (shouldSendToPerson(build)) {
    // TODO we need Jenkins for this?
    const person = null;
    if (person) {
      console.log(`Sending message to person: ${person}`);
    }
  }

  // Send message to the builds channel
  if (buildsChannel && shoudSendToBuildsChannel(build)) {
    console.log(`Sending message to builds channel: ${buildsChannel}`);
    const message = createSlackMessage(build, buildsChannel, project);
    new IncomingWebhook(config.SLACK_WEBHOOK_URL).send(message, callback);
  } else {
    return callback();
  }
};

// eventToBuild transforms pubsub event message to a build object.
const eventToBuild = (data) => {
  return JSON.parse(new Buffer(data, 'base64').toString());
};

const DEFAULT_COLOR = '#4285F4'; // blue
const STATUS_COLOR = {
  'SUCCESS': '#34A853', // green
  'FAILURE': '#EA4335', // red
  'TIMEOUT': '#FBBC05', // yellow
  'INTERNAL_ERROR': '#EA4335', // red
};

// createSlackMessage create a message from a build object.
const createSlackMessage = (build, channel, project) => {
  const icon_emoji = project ? project.iconEmoji : null;
  let icon_url = project ? project.iconUrl : null;

  if (!icon_emoji && !icon_url) {
    icon_url =
      'https://www.google.com/permissions/images/logo/google-cloud-logo.png';
  }

  let message = {
    username: 'Google Cloud Build',
    channel,
    icon_emoji,
    icon_url,
    text: shortName(build.source.repoSource.repoName)
      + ': *' + build.source.repoSource.branchName + '*',
    mrkdwn: true,
    attachments: [
      {
        title: 'Build logs',
        title_link: build.logUrl,
        color: STATUS_COLOR[build.status] || DEFAULT_COLOR,
        fields: [{
          title: 'Status',
          value: build.status
        }]
      }
    ]
  };
  return message;
};
