## APPENDIX A: Technology tutorials

### HTML and CSS

Tutorials and lessons:

* [w3schools: HTML tutorial and reference](https://www.w3schools.com/html/)
* [w3schools: CSS tutorial and reference](https://www.w3schools.com/css/)
* [Codecademy: Learn HTML](https://www.codecademy.com/learn/learn-html)
* [Codecademy: Learn CSS](https://www.codecademy.com/learn/learn-css)
* [A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
* [Flexbox Froggy](http://flexboxfroggy.com/)
* [A Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)

Fixes for some common issues:

* [Common CSS Issues For Front-End Projects](https://www.smashingmagazine.com/2018/12/common-css-issues-front-end-projects/)

### JavaScript

Introductions/tutorials:

* [JavaScript: The Good Parts](http://shop.oreilly.com/product/9780596517748.do) is an old classic and provides a good introduction to the language. It covers only the ES3 JavaScript specification, but it's a good read anyway.
* [ES6 for beginners](https://codeburst.io/es6-tutorial-for-beginners-5f3c4e7960be): This teaches you the new ES6 features.

JavaScript is typically executed in one thread only. This means that long running operations like API calls, database queries and file reads/writes should be executed asynchronously. That is, the single execution thread should not wait for an API call or database query to complete. The simplest way to achieve this is to use async/await:

* [ES2017 Async/Await](http://rossboucher.com/await/#/)
* [Learn Async/Await by Example](https://codeburst.io/javascript-es-2017-learn-async-await-by-example-48acc58bad65)

You should take the single threaded model into account also when processing a large amount of data. In such case you should break the execution in smaller chunks. This way you reserve the single thread only for a small period of time at once, and you also avoid loading large amount of data to memory at once.

### React

In React your UI consist of a component tree. For example:

```shell
App
  TopBar
  LeftDrawer
  Router
    Posts
      PostForm
        SubjectField
        AuthorField
        ContentField
        AddButton
      PostList
        Post 1
        Post 2
        Post 3
        Post 4
        ...
    Reports
      ...
    SearchRouter
      SearchPosts
        ...
      SearchImages
        ...
```

Most of these components should be presentational. That is, they know nothing about application state. They only render themselves by the properties that receive from their parent component, and they also pass along some of the properties to their children. If a presentational component contains some controls that should execute application logic (a button for example), the presentational component typically just calls a function, that it has received from its parent component as a property, when user uses that control.

Some of the components are containers. Container components know about application state, and about operations that are used to alter that state. In a simple application each container component may implement application logic and hold application state inside the component itself by using the state mechanism provided by React. In a more complex application, however, the application state and logic should reside outside the container component, and this is what libraries like [Redux](https://redux.js.org/) and [redux-saga](https://redux-saga.js.org/) are meant for: [When should I use Redux](https://redux.js.org/faq/general#when-should-i-use-redux).

#### Tutorials:

* [React: Tutorial](https://reactjs.org/tutorial/tutorial.html)
* [React: Main Concepts](https://reactjs.org/docs/hello-world.html)
* [Egghead: React](https://egghead.io/browse/frameworks/react): For example, [The Beginner's Guide to React](https://egghead.io/courses/the-beginner-s-guide-to-react) or [Start Learning React](https://egghead.io/courses/start-learning-react)

Additional libraries used in example implementation:

* [Styled components](https://www.styled-components.com/)
* [Material-UI](https://material-ui.com/)
* [Redux](https://redux.js.org/)
* [redux-saga](https://redux-saga.js.org/)

> TODO: In the future, use React hooks instead of Redux? Or use Redux with React hooks? Provide React hooks tutorials?

#### Browser extensions:

* [React DevTools](https://github.com/facebook/react-devtools)
* [Redux DevTools](https://github.com/reduxjs/redux-devtools)

#### Additional resources:

* [React Bits](https://vasanthk.gitbooks.io/react-bits/): TODO is this good?

### RESTful API

* [10 Best Practices for Better RESTful API](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/)

### GraphQL API

TODO

### SQL and relational databases

* [w3schools: SQL Tutorial and reference](https://www.w3schools.com/sql/)
* [Codecademy: Learn SQL](https://www.codecademy.com/learn/learn-sql)

---

**Next:** [APPENDIX B: Software design](/tutorial/b-software-design)
