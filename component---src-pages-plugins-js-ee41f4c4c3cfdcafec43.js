(window.webpackJsonp=window.webpackJsonp||[]).push([[6],{161:function(t,e,n){"use strict";n.r(e),n.d(e,"query",function(){return a});var r=n(4),i=(n(0),n(170)),o=n(177),c=n(175);e.default=function(t){var e=t.data,n=Object(i.c)(e,"md")[0];return Object(r.c)(o.a,null,Object(r.c)(c.a,null),Object(r.c)("div",{dangerouslySetInnerHTML:{__html:n.html}}))};var a="374385830"},170:function(t,e,n){"use strict";n.d(e,"c",function(){return p}),n.d(e,"b",function(){return f}),n.d(e,"e",function(){return b}),n.d(e,"a",function(){return m}),n.d(e,"d",function(){return x}),n.d(e,"f",function(){return v});var r=n(173),i=n.n(r),o=(n(40),n(84)),c=n.n(o),a=n(4),u=n(172);function l(){var t=i()(["",": ",""]);return l=function(){return t},t}function d(){var t=i()(["",": ",""]);return d=function(){return t},t}function s(){var t=i()(["",": ",""]);return s=function(){return t},t}var p=function(t,e){return void 0===e&&(e="allMarkdownRemark"),t[e].edges.map(function(t){var e=t.node,n=e.fields,r=void 0===n?{}:n,i=e.frontmatter,o=void 0===i?{}:i,a=c()(e,["fields","frontmatter"]);return Object.assign({},a,r,o)})},f=function(t,e){void 0===e&&(e="markdownRemark");var n=t[e],r=n.fields,i=void 0===r?{}:r,o=n.frontmatter,a=void 0===o?{}:o,u=c()(n,["fields","frontmatter"]);return Object.assign({},u,i,a)},b={name:"1x42tg8",styles:"@media screen and (min-width:34em){display:none;}"},m={name:"17ar87p",styles:"@media screen and (max-width:34em){display:none;}"},g=function(t){return t/16+"em"},x={sm:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(a.b)("@media screen and (max-width:",g(u.a.sm),"){",a.b.apply(void 0,[t].concat(n)),"}")},md:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(a.b)("@media screen and (min-width:",g(u.a.sm+1),") and (max-width:",g(u.a.lg-1),"){",a.b.apply(void 0,[t].concat(n)),"}")},lg:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(a.b)("@media screen and (min-width:",g(u.a.lg),"){",a.b.apply(void 0,[t].concat(n)),"}")}},h=function(t,e,n){return!(!t[e]||void 0===t[e][n])},v=function(t,e,n){return function(r){var i=function(t){return n?n[t]:t};return"string"==typeof r[t]?e+": "+i(r[t])+";":Object(a.b)(h(r,t,"lg")&&x.lg(s(),e,i(r[t].lg))," ",h(r,t,"md")&&x.md(d(),e,i(r[t].md))," ",h(r,t,"sm")&&x.sm(l(),e,i(r[t].sm)))}}},172:function(t,e,n){"use strict";n.d(e,"b",function(){return r}),n.d(e,"a",function(){return i});var r="undefined"!=typeof window,i={sm:700,lg:1025}},174:function(t,e,n){"use strict";var r=n(171),i=n(4),o=n(0),c=n.n(o),a=n(178),u=n(62),l=n(1),d=n.n(l),s=n(170),p=n(172).b?Math.min(360,.8*window.innerWidth):360,f=3,b=2,m=1,g={buttonPosition:d.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:d.a.node},x=function(t){var e=t.buttonPosition,n=t.buttonIcon,r=t.children,o=c.a.useState(!1),l=o[0],d=o[1];return Object(i.c)(c.a.Fragment,null,Object(i.c)(k,{onClick:function(){return d(!0)},position:e},n||Object(i.c)(a.b,null)),Object(i.c)(h,{isVisible:l,onClick:function(){return d(!1)}}),Object(i.c)(v,{isOpen:l},c.a.Children.map(r,function(t,e){return c.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,d(!1),void setTimeout(function(){return Object(u.navigate)(e)},400);var e}})})))},h=Object(r.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",b,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",s.e,";"),v=Object(r.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",f,";top:0;bottom:0;left:0;overflow-y:auto;width:",p,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-p-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",s.e,";"),y=Object(r.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),j={name:"vced1a",styles:"top:8px;left:8px;"},O={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(r.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",m,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&j}," ",function(t){return"top-right"===t.position&&O}," ",function(t){return"bottom-right"===t.position&&w}," ",s.e,";");x.Item=y,x.propTypes=g,x.defaultProps={buttonPosition:"top-right"},e.a=x},175:function(t,e,n){"use strict";var r=n(4),i=n(176),o=(n(0),n(179)),c=n(1),a=n.n(c),u=n(62),l=function(t){var e=t.title,n=t.description;return Object(r.c)(u.StaticQuery,{query:d,render:function(t){var i=t.site.siteMetadata,c=i.defaultTitle,a=i.defaultDescription,u={title:e||c,description:n||a};return Object(r.c)(o.Helmet,{title:u.title},Object(r.c)("meta",{name:"description",content:u.description}),u.title&&Object(r.c)("meta",{property:"og:title",content:u.title}),u.description&&Object(r.c)("meta",{property:"og:description",content:u.description}),u.title&&Object(r.c)("meta",{name:"twitter:title",content:u.title}),u.description&&Object(r.c)("meta",{name:"twitter:description",content:u.description}))},data:i})};e.a=l,l.propTypes={title:a.a.string,description:a.a.string},l.defaultProps={title:null,description:null};var d="1858091358"},176:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},177:function(t,e,n){"use strict";var r=n(173),i=n.n(r),o=n(84),c=n.n(o),a=n(171),u=n(4),l=(n(0),n(170)),d=n(62),s=n(63),p=Object(a.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",l.a),f=Object(a.a)(d.Link,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),b=function(){var t={fontWeight:500,borderColor:s.a.primary[500]};return Object(u.c)(p,null,Object(u.c)(f,{to:"/"},Object(u.c)("strong",null,"Taito")," CLI"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)(f,{to:"/docs",activeStyle:t,partiallyActive:!0},"Docs"),Object(u.c)(f,{to:"/tutorial",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(u.c)(f,{to:"/plugins",activeStyle:t},"Plugins"),Object(u.c)(f,{to:"/templates",activeStyle:t},"Templates"),Object(u.c)(f,{to:"/extensions",activeStyle:t},"Extensions"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)("div",null,"Search"),Object(u.c)("div",null,"Github lin"))},m=n(174),g=Object(a.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),x=function(){return Object(u.c)(g,null,"Footer lol")};function h(){var t=i()(["\n    margin-top: 40px;\n  "]);return h=function(){return t},t}var v=Object(a.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),y=Object(a.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",l.d.sm(h())),j=Object(a.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a{color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,r=t.children,i=c()(t,["menu","children"]);return Object(u.c)(v,i,Object(u.c)(y,null,n,Object(u.c)(j,null,r)),Object(u.c)(x,null),Object(u.c)(b,null),Object(u.c)(m.a,null,Object(u.c)(m.a.Item,{to:"/"},"Home"),Object(u.c)(m.a.Item,{to:"/docs"},"Docs"),Object(u.c)(m.a.Item,{to:"/tutorial"},"Tutorial"),Object(u.c)(m.a.Item,{to:"/plugins"},"Plugins"),Object(u.c)(m.a.Item,{to:"/templates"},"Templates"),Object(u.c)(m.a.Item,{to:"/extensions"},"Extensions")))}}}]);
//# sourceMappingURL=component---src-pages-plugins-js-ee41f4c4c3cfdcafec43.js.map