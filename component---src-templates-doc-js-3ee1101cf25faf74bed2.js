(window.webpackJsonp=window.webpackJsonp||[]).push([[10],{156:function(t,e,n){"use strict";n.r(e),n.d(e,"default",function(){return m}),n.d(e,"pageQuery",function(){return b});var r=n(4),i=(n(0),n(175)),o=n(164),a=n(167),c=n(174),u=n(172),l=n(177),d=n(178),s=n(179),p=n(170),f=function(t){return!!a.b&&window.location.pathname===t};function m(t){var e=t.data,n=Object(o.c)(e,"menu");return Object(r.c)(c.a,{menu:Object(r.c)(s.a,null,Object(r.c)(l.a,{size:14,weight:200},"DOCUMENTATION"),Object(r.c)(d.a,{dir:"vertical"}),n.map(function(t){return Object(r.c)(s.a.Item,{key:t.id,to:t.slug,isActive:f(t.slug)},t.headings.length>0?t.headings[0].value:"Missing heading!")}))},Object(r.c)(u.a,null),Object(r.c)("div",{dangerouslySetInnerHTML:{__html:e.doc.html}}),Object(r.c)(p.a,{buttonPosition:"bottom-right",buttonIcon:Object(r.c)(i.a,null)},n.map(function(t){return Object(r.c)(p.a.Item,{key:t.id,to:t.slug,isActive:f(t.slug)},t.headings.length>0?t.headings[0].value:"Missing heading!")})))}var b="1158978137"},164:function(t,e,n){"use strict";n.d(e,"c",function(){return p}),n.d(e,"b",function(){return f}),n.d(e,"e",function(){return m}),n.d(e,"a",function(){return b}),n.d(e,"d",function(){return h}),n.d(e,"f",function(){return v});var r=n(169),i=n.n(r),o=(n(60),n(82)),a=n.n(o),c=n(4),u=n(167);function l(){var t=i()(["",": ",""]);return l=function(){return t},t}function d(){var t=i()(["",": ",""]);return d=function(){return t},t}function s(){var t=i()(["",": ",""]);return s=function(){return t},t}var p=function(t,e){return void 0===e&&(e="allMarkdownRemark"),t[e].edges.map(function(t){var e=t.node,n=e.fields,r=void 0===n?{}:n,i=e.frontmatter,o=void 0===i?{}:i,c=a()(e,["fields","frontmatter"]);return Object.assign({},c,r,o)})},f=function(t,e){void 0===e&&(e="markdownRemark");var n=t[e],r=n.fields,i=void 0===r?{}:r,o=n.frontmatter,c=void 0===o?{}:o,u=a()(n,["fields","frontmatter"]);return Object.assign({},u,i,c)},m={name:"1x42tg8",styles:"@media screen and (min-width:34em){display:none;}"},b={name:"17ar87p",styles:"@media screen and (max-width:34em){display:none;}"},g=function(t){return t/16+"em"},h={sm:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(c.b)("@media screen and (max-width:",g(u.a.sm),"){",c.b.apply(void 0,[t].concat(n)),"}")},md:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(c.b)("@media screen and (min-width:",g(u.a.sm+1),") and (max-width:",g(u.a.lg-1),"){",c.b.apply(void 0,[t].concat(n)),"}")},lg:function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];return Object(c.b)("@media screen and (min-width:",g(u.a.lg),"){",c.b.apply(void 0,[t].concat(n)),"}")}},x=function(t,e,n){return!(!t[e]||void 0===t[e][n])},v=function(t,e,n){return function(r){var i=function(t){return n?n[t]:t};return"string"==typeof r[t]?e+": "+i(r[t])+";":Object(c.b)(x(r,t,"lg")&&h.lg(s(),e,i(r[t].lg))," ",x(r,t,"md")&&h.md(d(),e,i(r[t].md))," ",x(r,t,"sm")&&h.sm(l(),e,i(r[t].sm)))}}},165:function(t,e,n){"use strict";n.d(e,"b",function(){return s});var r=n(4),i=n(0),o=n.n(i),a=n(5),c=n.n(a),u=n(38),l=n.n(u);n.d(e,"a",function(){return l.a}),n.d(e,"c",function(){return u.navigate});n(168);var d=o.a.createContext({}),s=function(t){return Object(r.c)(d.Consumer,null,function(e){return t.data||e[t.query]&&e[t.query].data?(t.render||t.children)(t.data?t.data.data:e[t.query].data):Object(r.c)("div",null,"Loading (StaticQuery)")})};s.propTypes={data:c.a.object,query:c.a.string.isRequired,render:c.a.func,children:c.a.func}},167:function(t,e,n){"use strict";n.d(e,"b",function(){return r}),n.d(e,"a",function(){return i});var r="undefined"!=typeof window,i={sm:700,lg:1025}},168:function(t,e,n){var r;t.exports=(r=n(171))&&r.default||r},170:function(t,e,n){"use strict";var r=n(166),i=n(4),o=n(0),a=n.n(o),c=n(175),u=n(165),l=n(5),d=n.n(l),s=n(164),p=n(167).b?Math.min(360,.8*window.innerWidth):360,f=3,m=2,b=1,g={buttonPosition:d.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:d.a.node},h=function(t){var e=t.buttonPosition,n=t.buttonIcon,r=t.children,o=a.a.useState(!1),l=o[0],d=o[1];return Object(i.c)(a.a.Fragment,null,Object(i.c)(k,{onClick:function(){return d(!0)},position:e},n||Object(i.c)(c.b,null)),Object(i.c)(x,{isVisible:l,onClick:function(){return d(!1)}}),Object(i.c)(v,{isOpen:l},a.a.Children.map(r,function(t,e){return a.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,d(!1),void setTimeout(function(){return Object(u.c)(e)},400);var e}})})))},x=Object(r.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",m,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",s.e,";"),v=Object(r.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",f,";top:0;bottom:0;left:0;overflow-y:auto;width:",p,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-p-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",s.e,";"),y=Object(r.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),j={name:"vced1a",styles:"top:8px;left:8px;"},O={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(r.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",b,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&j}," ",function(t){return"top-right"===t.position&&O}," ",function(t){return"bottom-right"===t.position&&w}," ",s.e,";");h.Item=y,h.propTypes=g,h.defaultProps={buttonPosition:"top-right"},e.a=h},171:function(t,e,n){"use strict";n.r(e);n(60);var r=n(0),i=n.n(r),o=n(5),a=n.n(o),c=n(62),u=n(2),l=function(t){var e=t.location,n=u.default.getResourcesForPathnameSync(e.pathname);return n?i.a.createElement(c.a,Object.assign({location:e,pageResources:n},n.json)):null};l.propTypes={location:a.a.shape({pathname:a.a.string.isRequired}).isRequired},e.default=l},172:function(t,e,n){"use strict";var r=n(4),i=n(173),o=(n(0),n(176)),a=n(5),c=n.n(a),u=n(165),l=function(t){var e=t.title,n=t.description;return Object(r.c)(u.b,{query:d,render:function(t){var i=t.site.siteMetadata,a=i.defaultTitle,c=i.defaultDescription,u={title:e||a,description:n||c};return Object(r.c)(o.Helmet,{title:u.title},Object(r.c)("meta",{name:"description",content:u.description}),u.title&&Object(r.c)("meta",{property:"og:title",content:u.title}),u.description&&Object(r.c)("meta",{property:"og:description",content:u.description}),u.title&&Object(r.c)("meta",{name:"twitter:title",content:u.title}),u.description&&Object(r.c)("meta",{name:"twitter:description",content:u.description}))},data:i})};e.a=l,l.propTypes={title:c.a.string,description:c.a.string},l.defaultProps={title:null,description:null};var d="1858091358"},173:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},174:function(t,e,n){"use strict";var r=n(169),i=n.n(r),o=n(82),a=n.n(o),c=n(166),u=n(4),l=n(0),d=n.n(l),s=n(164),p=n(165),f=n(167),m=n(61),b=Object(c.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",s.a),g=Object(c.a)(p.a,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),h=function(){var t={fontWeight:500,borderColor:m.a.primary[500]};return Object(u.c)(b,null,Object(u.c)(g,{to:"/"},Object(u.c)("strong",null,"Taito")," CLI"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)(g,{to:"/docs/",activeStyle:t,partiallyActive:!0},"Docs"),Object(u.c)(g,{to:"/tutorial/",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(u.c)(g,{to:"/plugins/",activeStyle:t},"Plugins"),Object(u.c)(g,{to:"/templates/",activeStyle:t},"Templates"),Object(u.c)(g,{to:"/extensions/",activeStyle:t},"Extensions"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)("div",null,"Search"),Object(u.c)("div",null,"Github lin"))},x=n(170),v=Object(c.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),y=function(){return Object(u.c)(v,null,"Footer lol")};function j(){var t=i()(["\n    margin-top: 40px;\n  "]);return j=function(){return t},t}var O=Object(c.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),w=Object(c.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",s.d.sm(j())),k=Object(c.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a{color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,r=t.children,i=a()(t,["menu","children"]);return d.a.useEffect(function(){if(f.b){var t=window.location.pathname.length-1;"/"!==window.location.pathname[t]&&Object(p.c)(window.location.pathname+"/")}},[]),Object(u.c)(O,i,Object(u.c)(w,null,n,Object(u.c)(k,null,r)),Object(u.c)(y,null),Object(u.c)(h,null),Object(u.c)(x.a,null,Object(u.c)(x.a.Item,{to:"/"},"Home"),Object(u.c)(x.a.Item,{to:"/docs/"},"Docs"),Object(u.c)(x.a.Item,{to:"/tutorial/"},"Tutorial"),Object(u.c)(x.a.Item,{to:"/plugins/"},"Plugins"),Object(u.c)(x.a.Item,{to:"/templates/"},"Templates"),Object(u.c)(x.a.Item,{to:"/extensions/"},"Extensions")))}},177:function(t,e,n){"use strict";var r=n(166),i=n(164),o=Object(r.a)("span",{target:"e1h3ia970"})("margin:0;padding:0;font-family:'Raleway',sans-serif;font-size:",function(t){return t.size||16},"px;font-weight:",function(t){return t.weight||400},";color:",function(t){return t.color||t.theme.black},";line-height:",function(t){return t.lineh||1.5},";",Object(i.f)("size","font-size"));e.a=o},178:function(t,e,n){"use strict";var r=n(169),i=n.n(r),o=n(166),a=n(164);function c(){var t=i()(["",""]);return c=function(){return t},t}function u(){var t=i()(["",""]);return u=function(){return t},t}function l(){var t=i()(["",""]);return l=function(){return t},t}var d=function(t){switch(t){case"horizontal":return"width";case"vertical":return"height";default:return"width"}},s=function(t,e){var n=e.dir,r=e.amount||t.amount||16;return d(n||t.dir)+": "+r+"px;"},p=Object(o.a)("div",{target:"eemuqzb0"})("height:0px;",function(t){return function(t){var e=t.amount||16;return d(t.dir)+": "+e+"px;"}(t)}," ",function(t){return t.sm&&a.d.sm(l(),s(t,t.sm))}," ",function(t){return t.md&&a.d.md(u(),s(t,t.md))}," ",function(t){return t.lg&&a.d.lg(c(),s(t,t.lg))});e.a=p},179:function(t,e,n){"use strict";var r=n(166),i=n(165),o=n(164),a=Object(r.a)("div",{target:"e1x9yu0a0"})("width:320px;min-height:100vh;border-right:1px solid ",function(t){return t.theme.grey[300]},";display:flex;flex-direction:column;padding:16px 0px 16px 24px;",o.a),c=Object(r.a)(i.a,{target:"e1x9yu0a1"})("margin-left:-24px;padding:8px 16px 8px 24px;text-decoration:none;color:#222;position:relative;&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:20px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}&::after{display:",function(t){return t.isActive?"none":"block"},";font-size:16px;color:",function(t){return t.theme.primary[500]},";position:absolute;right:12px;top:50%;transform:translateY(-50%);}&:hover{background-color:",function(t){return t.theme.primary[100]},";color:",function(t){return t.theme.primary[700]},";&::after{content:'›';}}",o.a);a.Item=c,e.a=a}}]);
//# sourceMappingURL=component---src-templates-doc-js-3ee1101cf25faf74bed2.js.map