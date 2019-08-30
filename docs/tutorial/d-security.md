## APPENDIX D: Security

TODO This is short list of ... For more, see OWASP.

Frontend:

* [ ] **Google Analytics:** You should not send any personally identifiable information to Google Analytics, see [Best practices to avoid sending Personally Identifiable Information](https://support.google.com/analytics/answer/6366371?hl=en).
* TODO...

Backend:

* [ ] **HTTP access logs:** Paths and query parameters of HTTP requests end up in access logs. They should not contain any sensitive information. Use request headers or body instead.
* [ ] **Excessive logging:** You should never log all request headers or body content in production environment, or full user details, as they might contain sensitive information like security tokens or personal details.
* [ ] **SQL injection:** TODO ... You should consider also javascript property names and query parameters names as user input because `{ "DELETE * FROM USERS": "true" }` is valid json.
* [ ] **Global URL path matching bypass:** Some router libraries (e.g. koa-router) do not use exact URL path matching by default. If you implement global URL path matching, there might be ways to call a route with an URL that bypasses that global logic if you are not careful. Even worse, router library path matching logic might change some way once library is upgraded to a newer version.
* [ ] **Global authorization bypass:** There should be authorization in place on route or service level in addition to the global token handling (see `Global URL path matching bypass`).
* [ ] **CORS disable:** TODO ...

---

**Next:** [APPENDIX E: Data protection and privacy](e-data-protection-and-privacy.md)
