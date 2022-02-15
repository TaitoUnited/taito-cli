## APPENDIX B: Software design

### Modular structure

Many tutorials introduce you a monolithic application structure: put all application state in this directory, put all application actions into another directory. This is easy to understand and works ok for a small application, but it starts to become problematic once the codebase grows larger. Another approach would be to split the frontend into separate micro frontends and the backend into separate microservices. But this can be a bit overkill approach for most applications. When in doubt, a monolithic implementation with a modular structure is often the best approach for quickly building the first MVP or prototype. When done correctly, the modular structure can easily be split into separate micro frontends and microservices later once required.

Whether you are building a monolithic implementation or separate micro frontends and microservices, an application or API codebase should always be divided into loosely coupled highly cohesive parts by using a modular structure. Even if the monolithic implementation is not going to be split into micro frontends and microservices later, the modular structure provides many benefits, for example:

- When making a change, it's easier to see how widely the change might affect the application.
- When implementing a new feature, there is no need to jump around in the codebase as much.
- It's easier for a new developer to implement new features without knowing the whole codebase.
- Once the application grows and time passes, it's easier to rewrite some parts of the application using a newer technology without affecting the other parts.

The following guidelines usually work well when building a modular monolithic implementation:

- Create directory structure mainly based on domain concepts (`billing`, `management`, `trip`, ...) instead of technical type or layer (`actions`, `containers`, `components`, `css`, `utils`, ...).
- Inside these domain based modules you can use technical type or layer as folder structure, if you wish, but it is not always necessary.
- Use event-based communication to resolve any circular dependencies between the modules. That is, one module produces events that the other modules can listen to, if they are interested in such an event.

Think about the following concepts while you are working with your project:

- **Loose coupling:** Aim for loose coupling between different parts by defining a clear contract between the parts, minimizing the number of dependencies and avoiding circular dependencies altogether.
- **High cohesion:** Aim for high cohesion by putting closely related logic in the same place.
- **Responsibility:** Name the part according to its responsibility. The part should implement only such logic that it's responsible for and nothing else!

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

#### GraphQL API design

TODO

#### RESTful API design

Some good articles on REST API design:

- [best-practices-for-a-pragmatic-restful-api](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)
- [10-best-practices-for-better-restful-api](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/)
- [API-design-choosing-between-names-and-identifiers-in-URLs](https://cloudplatform.googleblog.com/2017/10/API-design-choosing-between-names-and-identifiers-in-URLs.html)
- [Google API Design Guide](https://cloud.google.com/apis/design/)
- [jsonapi.org](http://jsonapi.org/): Remember KISS principle! JSON API seems to be a bit over-engineered for the needs of a simple web application, but provides some good ideas.
- [How to design APIs that last](http://apiux.com/2014/09/05/api-design-sustainability/)
- [API design anti-patterns](http://www.slideshare.net/JasonHarmon1/api-design-antipatterns-54493635)

### Relational database design

- [introduction-db-modeling](http://www.datanamic.com/support/lt-dez005-introduction-db-modeling.html)
- [7-common-database-design-errors](http://www.vertabelo.com/blog/technical-articles/7-common-database-design-errors)
- [how-to-get-database-design-horribly-wrong](https://www.simple-talk.com/sql/database-administration/how-to-get-database-design-horribly-wrong/)
- [five-simple-database-design-errors-you-should-avoid](https://www.simple-talk.com/sql/database-administration/five-simple-database-design-errors-you-should-avoid/)
- [Seven Deadly Sins of Database Design](https://edn.embarcadero.com/article/40466)

TODO: conventions for audit log and/or journal tables. Take GDPR into account.

---

**Next:** [APPENDIX C: Modern server infrastructure](c-modern-server-infrastructure.md)
