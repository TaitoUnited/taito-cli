(window.webpackJsonp=window.webpackJsonp||[]).push([[10],{162:function(t,n,e){"use strict";e.r(n),e.d(n,"default",function(){return m}),e.d(n,"pageQuery",function(){return b});var i=e(4),r=(e(0),e(178)),o=e(170),c=e(172),a=e(177),u=e(175),l=e(180),d=e(181),s=e(182),p=e(174),f=function(t){return!!c.b&&window.location.pathname===t};function m(t){var n=t.data,e=Object(o.c)(n,"menu");return Object(i.c)(a.a,{menu:Object(i.c)(s.a,null,Object(i.c)(l.a,{size:14,weight:200},"DOCUMENTATION"),Object(i.c)(d.a,{dir:"vertical"}),e.map(function(t){return Object(i.c)(s.a.Item,{key:t.id,to:t.slug,isActive:f(t.slug)},t.headings.length>0?t.headings[0].value:"Missing heading!")}))},Object(i.c)(u.a,null),Object(i.c)("div",{dangerouslySetInnerHTML:{__html:n.doc.html}}),Object(i.c)(p.a,{buttonPosition:"bottom-right",buttonIcon:Object(i.c)(r.a,null)},e.map(function(t){return Object(i.c)(p.a.Item,{key:t.id,to:t.slug,isActive:f(t.slug)},t.headings.length>0?t.headings[0].value:"Missing heading!")})))}var b="1158978137"},170:function(t,n,e){"use strict";e.d(n,"c",function(){return p}),e.d(n,"b",function(){return f}),e.d(n,"e",function(){return m}),e.d(n,"a",function(){return b}),e.d(n,"d",function(){return h}),e.d(n,"f",function(){return v});var i=e(173),r=e.n(i),o=(e(40),e(84)),c=e.n(o),a=e(4),u=e(172);function l(){var t=r()(["",": ",""]);return l=function(){return t},t}function d(){var t=r()(["",": ",""]);return d=function(){return t},t}function s(){var t=r()(["",": ",""]);return s=function(){return t},t}var p=function(t,n){return void 0===n&&(n="allMarkdownRemark"),t[n].edges.map(function(t){var n=t.node,e=n.fields,i=void 0===e?{}:e,r=n.frontmatter,o=void 0===r?{}:r,a=c()(n,["fields","frontmatter"]);return Object.assign({},a,i,o)})},f=function(t,n){void 0===n&&(n="markdownRemark");var e=t[n],i=e.fields,r=void 0===i?{}:i,o=e.frontmatter,a=void 0===o?{}:o,u=c()(e,["fields","frontmatter"]);return Object.assign({},u,r,a)},m={name:"1x42tg8",styles:"@media screen and (min-width:34em){display:none;}"},b={name:"17ar87p",styles:"@media screen and (max-width:34em){display:none;}"},g=function(t){return t/16+"em"},h={sm:function(t){for(var n=arguments.length,e=new Array(n>1?n-1:0),i=1;i<n;i++)e[i-1]=arguments[i];return Object(a.b)("@media screen and (max-width:",g(u.a.sm),"){",a.b.apply(void 0,[t].concat(e)),"}")},md:function(t){for(var n=arguments.length,e=new Array(n>1?n-1:0),i=1;i<n;i++)e[i-1]=arguments[i];return Object(a.b)("@media screen and (min-width:",g(u.a.sm+1),") and (max-width:",g(u.a.lg-1),"){",a.b.apply(void 0,[t].concat(e)),"}")},lg:function(t){for(var n=arguments.length,e=new Array(n>1?n-1:0),i=1;i<n;i++)e[i-1]=arguments[i];return Object(a.b)("@media screen and (min-width:",g(u.a.lg),"){",a.b.apply(void 0,[t].concat(e)),"}")}},x=function(t,n,e){return!(!t[n]||void 0===t[n][e])},v=function(t,n,e){return function(i){var r=function(t){return e?e[t]:t};return"string"==typeof i[t]?n+": "+r(i[t])+";":Object(a.b)(x(i,t,"lg")&&h.lg(s(),n,r(i[t].lg))," ",x(i,t,"md")&&h.md(d(),n,r(i[t].md))," ",x(i,t,"sm")&&h.sm(l(),n,r(i[t].sm)))}}},172:function(t,n,e){"use strict";e.d(n,"b",function(){return i}),e.d(n,"a",function(){return r});var i="undefined"!=typeof window,r={sm:700,lg:1025}},174:function(t,n,e){"use strict";var i=e(171),r=e(4),o=e(0),c=e.n(o),a=e(178),u=e(62),l=e(1),d=e.n(l),s=e(170),p=e(172).b?Math.min(360,.8*window.innerWidth):360,f=3,m=2,b=1,g={buttonPosition:d.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:d.a.node},h=function(t){var n=t.buttonPosition,e=t.buttonIcon,i=t.children,o=c.a.useState(!1),l=o[0],d=o[1];return Object(r.c)(c.a.Fragment,null,Object(r.c)(k,{onClick:function(){return d(!0)},position:n},e||Object(r.c)(a.b,null)),Object(r.c)(x,{isVisible:l,onClick:function(){return d(!1)}}),Object(r.c)(v,{isOpen:l},c.a.Children.map(i,function(t,n){return c.a.cloneElement(t,{key:n,onClick:function(){return n=t.props.to,d(!1),void setTimeout(function(){return Object(u.navigate)(n)},400);var n}})})))},x=Object(i.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",m,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",s.e,";"),v=Object(i.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",f,";top:0;bottom:0;left:0;overflow-y:auto;width:",p,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-p-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",s.e,";"),y=Object(i.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),O={name:"vced1a",styles:"top:8px;left:8px;"},j={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(i.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",b,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&O}," ",function(t){return"top-right"===t.position&&j}," ",function(t){return"bottom-right"===t.position&&w}," ",s.e,";");h.Item=y,h.propTypes=g,h.defaultProps={buttonPosition:"top-right"},n.a=h},175:function(t,n,e){"use strict";var i=e(4),r=e(176),o=(e(0),e(179)),c=e(1),a=e.n(c),u=e(62),l=function(t){var n=t.title,e=t.description;return Object(i.c)(u.StaticQuery,{query:d,render:function(t){var r=t.site.siteMetadata,c=r.defaultTitle,a=r.defaultDescription,u={title:n||c,description:e||a};return Object(i.c)(o.Helmet,{title:u.title},Object(i.c)("meta",{name:"description",content:u.description}),u.title&&Object(i.c)("meta",{property:"og:title",content:u.title}),u.description&&Object(i.c)("meta",{property:"og:description",content:u.description}),u.title&&Object(i.c)("meta",{name:"twitter:title",content:u.title}),u.description&&Object(i.c)("meta",{name:"twitter:description",content:u.description}))},data:r})};n.a=l,l.propTypes={title:a.a.string,description:a.a.string},l.defaultProps={title:null,description:null};var d="1858091358"},176:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},177:function(t,n,e){"use strict";var i=e(173),r=e.n(i),o=e(84),c=e.n(o),a=e(171),u=e(4),l=e(0),d=e.n(l),s=e(170),p=e(62),f=e(172),m=e(63),b=Object(a.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",s.a),g=Object(a.a)(p.Link,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),h=function(){var t={fontWeight:500,borderColor:m.a.primary[500]};return Object(u.c)(b,null,Object(u.c)(g,{to:"/"},Object(u.c)("strong",null,"Taito")," CLI"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)(g,{to:"/docs/",activeStyle:t,partiallyActive:!0},"Docs"),Object(u.c)(g,{to:"/tutorial/",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(u.c)(g,{to:"/plugins/",activeStyle:t},"Plugins"),Object(u.c)(g,{to:"/templates/",activeStyle:t},"Templates"),Object(u.c)(g,{to:"/extensions/",activeStyle:t},"Extensions"),Object(u.c)("div",{style:{flex:1}}),Object(u.c)("div",null,"Search"),Object(u.c)("div",null,"Github lin"))},x=e(174),v=Object(a.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),y=function(){return Object(u.c)(v,null,"Footer")};function O(){var t=r()(["\n    margin-top: 40px;\n  "]);return O=function(){return t},t}var j=Object(a.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),w=Object(a.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",s.d.sm(O())),k=Object(a.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a{color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");n.a=function(t){var n=t.menu,e=void 0===n?null:n,i=t.children,r=c()(t,["menu","children"]);return d.a.useEffect(function(){if(f.b){var t=window.location.pathname.length-1;"/"!==window.location.pathname[t]&&Object(p.navigate)(window.location.pathname+"/")}},[]),Object(u.c)(j,r,Object(u.c)(w,null,e,Object(u.c)(k,null,i)),Object(u.c)(y,null),Object(u.c)(h,null),Object(u.c)(x.a,null,Object(u.c)(x.a.Item,{to:"/"},"Home"),Object(u.c)(x.a.Item,{to:"/docs/"},"Docs"),Object(u.c)(x.a.Item,{to:"/tutorial/"},"Tutorial"),Object(u.c)(x.a.Item,{to:"/plugins/"},"Plugins"),Object(u.c)(x.a.Item,{to:"/templates/"},"Templates"),Object(u.c)(x.a.Item,{to:"/extensions/"},"Extensions")))}},180:function(t,n,e){"use strict";var i=e(171),r=e(170),o=Object(i.a)("span",{target:"e1h3ia970"})("margin:0;padding:0;font-family:'Raleway',sans-serif;font-size:",function(t){return t.size||16},"px;font-weight:",function(t){return t.weight||400},";color:",function(t){return t.color||t.theme.black},";line-height:",function(t){return t.lineh||1.5},";",Object(r.f)("size","font-size"));n.a=o},181:function(t,n,e){"use strict";var i=e(173),r=e.n(i),o=e(171),c=e(170);function a(){var t=r()(["",""]);return a=function(){return t},t}function u(){var t=r()(["",""]);return u=function(){return t},t}function l(){var t=r()(["",""]);return l=function(){return t},t}var d=function(t){switch(t){case"horizontal":return"width";case"vertical":return"height";default:return"width"}},s=function(t,n){var e=n.dir,i=n.amount||t.amount||16;return d(e||t.dir)+": "+i+"px;"},p=Object(o.a)("div",{target:"eemuqzb0"})("height:0px;",function(t){return function(t){var n=t.amount||16;return d(t.dir)+": "+n+"px;"}(t)}," ",function(t){return t.sm&&c.d.sm(l(),s(t,t.sm))}," ",function(t){return t.md&&c.d.md(u(),s(t,t.md))}," ",function(t){return t.lg&&c.d.lg(a(),s(t,t.lg))});n.a=p},182:function(t,n,e){"use strict";var i=e(171),r=e(62),o=e(170),c=Object(i.a)("div",{target:"e1x9yu0a0"})("width:320px;min-height:100vh;border-right:1px solid ",function(t){return t.theme.grey[300]},";display:flex;flex-direction:column;padding:16px 0px 16px 24px;",o.a),a=Object(i.a)(r.Link,{target:"e1x9yu0a1"})("margin-left:-24px;padding:8px 16px 8px 24px;text-decoration:none;color:#222;position:relative;&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:20px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}&::after{display:",function(t){return t.isActive?"none":"block"},";font-size:16px;color:",function(t){return t.theme.primary[500]},";position:absolute;right:12px;top:50%;transform:translateY(-50%);}&:hover{background-color:",function(t){return t.theme.primary[100]},";color:",function(t){return t.theme.primary[700]},";&::after{content:'›';}}",o.a);c.Item=a,n.a=c}}]);
//# sourceMappingURL=component---src-templates-doc-js-4408af006922a95067f0.js.map