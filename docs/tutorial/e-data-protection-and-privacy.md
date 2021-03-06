## APPENDIX E: Data protection and privacy (GDPR)

This section provides documentation and a checklist for data protection and privacy. Most of the checklist steps concern personal data (GDPR), but many of them can, and should, be applied to any confidential data to keep the data safe.

Glossary:

* **Personally identifiable information (PII):** Data that can be used to uniquely identify a person like name, home address, e-mail address, social-security number, or *anything directly connected to these identifiers such as purchase history*.
* **Special category data (extra-sensitive PII):** For example medical/health information, religion, sexual orientation, or any information on/collected from a minor.
* **Data controller:** The entity that determines the purposes, conditions and means of the processing of personal data. For example, the organization that owns the software system and its data.
* **Data processor:** The entity that processes data on behalf of the Data Controller. For example, the company that hosts the software system and provides tehcnical support.
* **[Data Protection Officer (DPO)](https://eugdprcompliant.com/what-is-a-data-protection-officer/):** Ensures that organisation processes personal data in compliance with data protection rules.

### Documentation

> TODO: Add documentation here (see checklist)

### Checklist

> Go through the checklist and leave a comment for each: `COMMENT: ...`.

Based on the following considerations you can determine how vigorously you should apply all the steps in the checklist:

* [ ] Does your system contain extra-sensitive information (special category data)?
* [ ] Does your system contain something that, while not sensitive for purposes of GDPR, would be embarrassing/dangerous to publish?
* [ ] If someone published your database content, how large risk would that be to your business?
* [ ] How large is your database of users?

Checklist:

* [ ] **Documentation:** You should document the following details at least for PII: the data in your system, lifecycles of collected data, all parties that process the data (or who can access it), your basis for collecting the data, data subjects rights and how they can exercise them. Dataflow diagram may be a good tool, if data is processed by multiple parties and systems. See [Documentation](#documentation).
* [ ] **Contracts:** The aforementioned documentation is taken into account in contracts between different parties (e.g. between data controller and data processors).
* [ ] **Privacy policy:** You should provide the aforementioned documentation also for users in the form of privacy policy (see the [example](https://gdpr.eu/wp-content/uploads/2019/01/Our-Company-Privacy-Policy.pdf)). Privacy policy should be detailed to provide a necessary level of transparency and must be written in such language that a common joe undestands. Note that privacy policy should include all processes and parties that handle the information, and thus it should be mainly written by the data controller.
* [ ] **User consent:** You must ask users to consent on the processing of their personal data in a clear and easily accessible form. You must be able to show that the user has consented, provide an easy way to withdraw consent at any time, and also ask consent again if changes have been made to the terms of service or privacy policy. Privacy consent needs to be given by means of a *clear affirmative act* which means that a pre-ticked checkbox doesn't suffice.  (TODO user consent is not required if: The basis for processing of personal data may be a contract, agreement, or transaction.)
* [ ] **User consent and children:** If the user is below the age of 16 years, the consent must given or authorised by the holder of parental responsibility over the child. NOTE: The age limit is 13 years in some countries (e.g Finland, UK and Ireland).
* [ ] **Terms of service:** It is convenient to ask consent for both the terms of service and privacy policy at the same time. This is ok, but both should be presented for user as separate documents to read. Terms of service is optional and it is not related to GDPR.
* [ ] **Data tagging:** You may need to tag data based on user consent. For example, has the user accepted data usage for marketing purposes.
* [ ] **Limited data access:** Grant access to personal data for only those who really need it. In most cases, a developer should not be a data processor, thus, a developer should not have access to any PII.
* [ ] **3rd parties:** If you hand over personal data to 3rd parties (e.g. by using 3rd party SaaS services), make sure that they are GDPR compliant, and you have user concent for doing so. You can, however, hand over data also to non-compliant parties if it is necessary for the process itself, and you have explicit user consent for doing so (for example, making hotel reservations). NOTE: Google Analytics [forbids](https://support.google.com/analytics/answer/6366371?hl=en) storing any personal data.
* [ ] **Rights for personal data:** Users have a right to access, correct, and erase all their personal data. A GUI implementation is not a requirement, but it's best that users can access, edit and delete their personal data themselves by using a GUI. This is not only more convenient, but in most cases also more secure, as it is hard to identify users reliably during human interaction. NOTE: You need to respond to the request of user within 30 days, and you may also refuse the request if you have a legitimate reason for doing so.
* [ ] **Data portability:** User has a right to receive the personal data concerning them in a structured, commonly used and machine-readable format. You don't need to implement a service for that, but keep this in mind.
* [ ] **Data minimization:** Personal data you collect must be limited to what is necessary, and must be kept only as long as needed. You should also consider automatic archival/erasure mechanims that anonymize or delete old PII data automatically, once it is no longer needed.
* [ ] **Data anonymization:** Anonymize data whenever it is possible. For example, retaining user reference is usually unnecessary when collecting history data for analytics. Note that anonymization is not a trivial task to do correctly as some users may still be identifiable from rare combinations of data.
* [ ] **Data pseudonymization:** You can limit PII access also by using pseudonymization. For example, keep all user identifying data in a separate system and reference the user with a generated user id elsewhere. However, just like anonymization, pseudonymization is not a trivial task to implement correctly.
* [ ] **Logging:** Keep PII out of the server logs, as logs often have a wider audience and different retention period than database data. Logging of anonymized or pseudonymized data is ok in most cases if the data does not contain otherwise critical details like credit card numbers or passwords. Review logs and, if it is necessary, consider log filtering either on the application or on the infrastructure level. There are also automatic log filtering tools that can filter some details automatically. NOTE: Beware HTTP query parameters as they end up in access logs.
* [ ] **Backups:** At this point you can assume that data need not be deleted from backups on user request, if the backup retention period is reasonable (e.g. 30 days). If you are required to keep backups of some data for a long period of time, consider pseudonymization and storing data to different databases based on requirements. NOTE: Be careful when restoring data from backups! You should not restore data that a user has previously deleted.
* [ ] **Data breach notification:** Users have a right to receive a notification about a data breach without undue delay, if the data breach is likely to result in a high risk to his rights and freedoms. Keep this in mind when choosing audit logging and an user management mechanisms. NOTE: Supervisory authority need to be informed not later than 72 hours after having become aware of the data breach.
* **Audit logging and reporting:** You should leave a clear audit trail when someone accesses another users PII. Otherwise you don't have enough data for notifying the supervisory authority, and the users in question. Therefore you'll have to assume that all PII of all users has been compromised.
  * [ ] **On application level:** For example, log these operations to a separate audit log table that can't be modified by users. Consider also ready-made audit mechanisms provided by databases and other tools. A GUI implementation is not necessary for viewing the entries. Note that audit log entries are also PII, but you have a valid excuse to refuse any modification/deletion requests on user's behalf.
  * [ ] **On infrastructure level:** This is not a trivial task, as it may be hard to prevent system administrators from accessing database with application credentials without leaving a clear audit trail that cannot be altered. However, most major gloud providers have very good audit logging mechanims that suffice, if used correctly.
* [ ] **Basic security mechanisms:** Take care of the basics like authentication, authorization, encrypting data on transit, firewall rules, and keeping software up-to-date.
* [ ] **Additional security mechanisms:** Of course, you may use additional security mechanisms like automatic intrusion detection mechanims, encrypting all data at rest, etc. But these are not absolutely necessary.

NOTE: There are some country based exceptions for the rules. For example in Finland, the aforementioned age limit is 13 years. There are also some exceptions made in Finland that guarantee freedom of speech and some specific cases of data processing that strive for common good.

Links:

* [gdpr-info.eu](https://gdpr-info.eu/)
* [glossary-of-terms](https://www.eugdpr.org/glossary-of-terms.html)
* [gdpr-for-software-devs](https://www.infoq.com/articles/gdpr-for-software-devs)
