## APPENDIX B: Software design

### Modular structure

Many tutorials introduce you a monolithic application structure: put all application state in this directory, put all application actions into another directory. This works ok for a very small application, but it starts to become problematic once the codebase grows larger. Another approach would be to split the frontend into separate micro frontends and the backend into separate microservices. But this can be a bit overkill approach for a small application or API. When in doubt, a monolithic implementation with a modular structure is often the best approach for quickly building the first MVP or prototype. When done correctly, the modular structure can easily be split into separate micro frontends and microservices once required.

Whether you are building a monolithic implementation or separate micro frontends and microservices, an application or API codebase should always be divided into loosely coupled highly cohesive parts by using a modular structure. Even if the monolithic implementation is not going to be split into micro frontends and microservices later, the modular structure provides many benefits, for example:

* When making a change, it's easier to see how widely the change might affect the application.
* When implementing a new feature, there is no need to jump around in the codebase as much.
* It's easier for a new developer to implement new features without knowing the whole codebase.
* Once the application grows and time passes, it's easier to rewrite some parts of the application using a newer technology without affecting the other parts.

The following guidelines usually work well when building a modular monolithic implementation:

* Create directory structure mainly based on domain concepts or features (`billing`, `management`, `trip`, ...) instead of technical type or layer (`actions`, `containers`, `components`, `css`, `utils`, ...).
* You can use event-based communication to avoid direct calls between loosely coupled parts. That is, one UI section or service produces events that the others can listen to, if they are interested in such an event.
* Use such file naming that you can easily determine the type from a filename (e.g. `*.util.js`, `*.api.js`). This way you don't need to use additional directories for grouping files by type. Thus, you can freely place a file wherever it is needed. NOTE: It is ok to exclude type from GUI component filenames to keep import statements shorter. Just make sure that you can easily determine type and responsibility from a filename, and that you use the same naming convention throughout the codebase.
* A directory should not contain any references outside of its boundary; with the exception of references to libraries and common directories. You can think of each directory as an independent concept (or subconcept), and each `common` directory as a library that is shared among closely related concepts (or subconcepts).
* A file should contain only nearby references (e.g. references to files in the same directory or in a subdirectory directly beneath it); with the exception of references to libraries and common directories, of course.
* If you break the guidelines, at least try to avoid making circular dependencies. Also leave a `REFACTOR:` comment if the dependency is the kind that it should be refactored later.

See [full-stack-template/client/src](https://github.com/TaitoUnited/full-stack-template/tree/master/client/src) as an example.

TODO: DRY, KISS, YAGNI, GRASP, SOLID
TODO: https://jaxenter.com/promising-new-metric-track-maintainability-154195.html
TODO: https://www.tutorialspoint.com/software_engineering/software_design_basics.htm

### API design

REST and GraphQL API implementations should be stateless. Stateless means that a service does not keep any state in memory or on local disk between requests. That is, all state resides either on UI, on database, or on some other external system. Services should be stateless because multiple instances of the same service will be run in parallel, and the request that an UI or 3rd party system makes, may be forwarded to any them. In addition, you should be able to publish a new version of the service any time without causing interruptions, which is harder to do if service is stateful. A stateless service should not:

- Cache data in local memory (tip: use Redis as cache, or keep state in UI and use JWT tokens if necessary)
- Use local disk for permanent data (tip: use object storage buckets)
- Define request rate limits (tip: define rate limits in Kubernetes ingress)
- Use local timers to execute jobs (tip: use Kubernetes cron jobs)
- TODO stateless websockets

#### RESTful API design

Some good articles on REST API design:

* [best-practices-for-a-pragmatic-restful-api](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)
* [10-best-practices-for-better-restful-api](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/)
* [API-design-choosing-between-names-and-identifiers-in-URLs](https://cloudplatform.googleblog.com/2017/10/API-design-choosing-between-names-and-identifiers-in-URLs.html)
* [Google API Design Guide](https://cloud.google.com/apis/design/)
* [jsonapi.org](http://jsonapi.org/): Remember KISS principle! JSON API seems to be a bit over-engineered for the needs of a simple web application, but provides some good ideas.
* [How to design APIs that last](http://apiux.com/2014/09/05/api-design-sustainability/)
* [API design anti-patterns](http://www.slideshare.net/JasonHarmon1/api-design-antipatterns-54493635)

#### GraphQL API design

TODO

### Relational database design

* [introduction-db-modeling](http://www.datanamic.com/support/lt-dez005-introduction-db-modeling.html)
* [7-common-database-design-errors](http://www.vertabelo.com/blog/technical-articles/7-common-database-design-errors)
* [how-to-get-database-design-horribly-wrong](https://www.simple-talk.com/sql/database-administration/how-to-get-database-design-horribly-wrong/)
* [five-simple-database-design-errors-you-should-avoid](https://www.simple-talk.com/sql/database-administration/five-simple-database-design-errors-you-should-avoid/)
* [Seven Deadly Sins of Database Design](https://edn.embarcadero.com/article/40466)

TODO: conventions for audit log and/or journal tables. Take GDPR into account.

### TODO some copy-pasted old text

#### Structure

Think about the following concepts while you are working with your project. You can apply them no matter whether you are working with services, modules, directories, classes or just plain methods and functions. Do not blindly follow structure shown on tutorials or starter templates since those are really meant for quick start only.

* **Loose coupling:** Aim for loose coupling between different parts by defining a clear contract between the parts, minimizing the number of dependencies and avoiding circular dependencies altogether.
* **High cohesion:** Aim for high cohesion by putting closely related logic in the same place.
* **Responsibility:** Name the part according to its responsibility. The part should implement only such logic that it's responsible for and nothing else!

See [full-stack-template](https://github.com/TaitoUnited/full-stack-template) as an example of a directory structure. This kind of loosely coupled modular structure has many benefits including:

* When you make changes to an existing implementation, you know better how widely the change will affect the rest of the application (what might break).
* When you make changes to a feature, you don't have to jump around in the code tree searching for the correct places that you need to change.
* If you just started in the project as a new developer, you don't have to understand the whole application; only the loosely coupled parts that you are working with.
* It is easier to write and maintain unit/integration tests.
* If the application has grown large, it is easier to split it into parts that are deployed to server or loaded to browser independently.
* If the application is old, it is easier to develop new features using a modern technology and migrate old parts one by one only when it is really necessary.

#### Naming

As stated previously, each part should be named according to its responsibility. But naming can be hard. The following resources might provide some help in finding well established common terminology. Knowing the most commonly used design patterns doesn't hurt either, but there is no need to learn all of them.

* TODO modern terminology: ...
* TODO basic terminology: service, dao, repository, ...
* [GoF Design Patterns](http://www.blackwasp.co.uk/gofpatterns.aspx)

#### Tips

* Avoid premature optimization. During implementation of a single feature, it's best to invest on code maintainability and optimize only if it's really necessary. More often than not optimization requires additional work and weakens maintainability.

---

**Next:** [APPENDIX C: Modern server infrastructure](c-modern-server-infrastructure.md)
