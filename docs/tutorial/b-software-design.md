## APPENDIX B: Software design

https://www.tutorialspoint.com/software_engineering/software_design_basics.htm

### Stateless services

The API should be implemented as stateless services. Stateless means that a service does not keep any state in memory or on local disk between requests. That is, all state resides either on UI, on database, or on some other external system. Services should be stateless because multiple instances of the same service will be run in parallel, and the request that the UI makes, may be forwarded to any them. In addition, you should be able to publish a new version of the service without causing interruptions, which is harder to do if service is stateful. A stateless service should not:

- Cache data in local memory (tip: use Redis as cache, or keep state in UI and use JWT tokens if necessary)
- Use local disk for permanent data (tip: use object storage buckets)
- Define request rate limits (tip: define rate limits in Kubernetes ingress)
- Use local timers to execute jobs (tip: use Kubernetes cron jobs)
- TODO stateless websockets

### Code structure


TODO:

* DRY
* KISS
* YAGNI
* GRASP
* SOLID

An implementation should be divided in loosely coupled highly cohesive parts by using a modular directory structure. Some benefits of this kind of structure:

* When making a change, it's easier to see how widely the change might affect the application.
* When implementing a new feature, there is no need to jump around in the codebase as much.
* It's easier for a new developer to implement new features without knowing the whole codebase.
* Once the application grows, it's easier to split it into smaller parts that can be built and deployed independently.
* Once the application grows and time passes, it's easier to rewrite some parts of the application using a newer technology without affecting the other parts.

The following guidelines usually work well at least for a GUI implementation. You might need to break the guidelines once in a while, but still try to keep directories loosely coupled.

* Create directory structure mainly based on domain concepts or features (`area`, `billing`, `trip`, `user`, ...) instead of technical type or layer (`actions`, `containers`, `components`, `css`, `utils`, ...).
* Use such file naming that you can easily determine the type from a filename (e.g. `*.util.js`, `*.api.js`). This way you don't need to use additional directories for grouping files by type. Thus, you can freely place a file wherever it is needed. NOTE: It is ok to exclude type from GUI component filenames to keep import statements shorter. Just make sure that you can easily determine type and responsibility from a filename, and that you use the same naming convention throughout the codebase.
* A directory should not contain any references outside of its boundary; with the exception of references to libraries and common directories. You can think of each directory as an independent concept (or subconcept), and each `common` directory as a library that is shared among closely related concepts (or subconcepts).
* A file should contain only nearby references (e.g. references to files in the same directory or in a subdirectory directly beneath it); with the exception of references to libraries and common directories, of course.
* You cannot always follow the dependency guidelines mentioned above. If you break the guidelines, at least try to avoid making circular dependencies between directories. Also leave a `REFACTOR:` comment if the dependency is the kind that it should be refactored later.

See [kubernetes-template/client/src](https://github.com/TaitoUnited/server-template/tree/master/client/src) as an example.

---

**Next:** [APPENDIX C: SSL/TLS certificates](c-certificates.md)
