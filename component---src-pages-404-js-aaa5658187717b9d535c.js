(window.webpackJsonp=window.webpackJsonp||[]).push([[2],{170:function(t,e,n){"use strict";n.r(e);var i=n(1),o=(n(0),n(181)),r=n(179);e.default=function(){return Object(i.d)(o.a,null,Object(i.d)(r.a,null),Object(i.d)("h1",null,"NOT FOUND"),Object(i.d)("p",null,"You just hit a route that doesn't exist..."))}},177:function(t,e,n){"use strict";var i=n(176),o=n(1),r=n(0),a=n.n(r),c=n(185),l=n(68),d=n(2),u=n.n(d),s=n(67),p=n(13).b?Math.min(360,.8*window.innerWidth):360,b=3,f=2,m=1,g={buttonPosition:u.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:u.a.node},x=function(t){var e=t.buttonPosition,n=t.buttonIcon,i=t.children,r=a.a.useState(!1),d=r[0],u=r[1];return Object(o.d)(a.a.Fragment,null,Object(o.d)(k,{onClick:function(){return u(!0)},position:e},n||Object(o.d)(c.b,null)),Object(o.d)(h,{isVisible:d,onClick:function(){return u(!1)}}),Object(o.d)(j,{isOpen:d},a.a.Children.map(i,function(t,e){return a.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,u(!1),void setTimeout(function(){return Object(l.navigate)(e)},400);var e}})})))},h=Object(i.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",f,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",s.e,";"),j=Object(i.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",b,";top:0;bottom:0;left:0;overflow-y:auto;width:",p,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-p-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",s.e,";"),O=Object(i.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),y={name:"vced1a",styles:"top:8px;left:8px;"},v={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(i.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",m,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&y}," ",function(t){return"top-right"===t.position&&v}," ",function(t){return"bottom-right"===t.position&&w}," ",s.e,";");x.Item=O,x.propTypes=g,x.defaultProps={buttonPosition:"top-right"},e.a=x},179:function(t,e,n){"use strict";var i=n(1),o=n(180),r=(n(0),n(189)),a=n(2),c=n.n(a),l=n(68),d=function(t){var e=t.title,n=t.description;return Object(i.d)(l.StaticQuery,{query:u,render:function(t){var o=t.site.siteMetadata,a=o.defaultTitle,c=o.defaultDescription,l={title:e||a,description:n||c};return Object(i.d)(r.Helmet,{title:l.title},Object(i.d)("meta",{name:"description",content:l.description}),l.title&&Object(i.d)("meta",{property:"og:title",content:l.title}),l.description&&Object(i.d)("meta",{property:"og:description",content:l.description}),l.title&&Object(i.d)("meta",{name:"twitter:title",content:l.title}),l.description&&Object(i.d)("meta",{name:"twitter:description",content:l.description}))},data:o})};e.a=d,d.propTypes={title:c.a.string,description:c.a.string},d.defaultProps={title:null,description:null};var u="1858091358"},180:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},181:function(t,e,n){"use strict";var i=n(20),o=n.n(i),r=n(32),a=n.n(r),c=n(176),l=n(1),d=n(0),u=n.n(d),s=n(67),p=n(68),b=n(33),f=n(2),m=n.n(f),g=n(186),x=n.n(g),h=n(188),j=n(543),O=n(545),y=n(546),v=n(544),w=x()("KG2PVUXA5L","c744101a7faa04ad219b22127a719755"),k=function(t){var e=t.hit,n=e.objectID,i=e.slug,o=e.pageHeading,r=e.parentHeading,a=r?function(t,e){var n=t.length-1;return("/"===t[n]?t.substr(0,n):t)+"#"+Object(s.g)(e)}(i,r):i;return Object(l.d)(C,{to:a,key:n},Object(l.d)(q,null,o),Object(l.d)(v.a,{hit:e,attribute:"content",tagName:"mark"}))},I=Object(c.a)("div",{target:"e1eqr9hl0"})({name:"79elbk",styles:"position:relative;"}),T=Object(c.a)("div",{target:"e1eqr9hl1"})({name:"5is3sl",styles:"position:absolute;top:40px;right:0px;width:400px;max-height:400px;overflow-y:auto;background-color:#fff;border-radius:4px;box-shadow:0px 4px 12px rgba(0,0,0,0.2);ul{list-style:none !important;padding:0 !important;margin:0 !important;li{margin-bottom:8px;}}"}),q=Object(c.a)("div",{target:"e1eqr9hl2"})({name:"10v4ul9",styles:"padding:4px;background-color:#222;color:#fff;font-weight:500;font-size:14px;margin:0px -16px 4px -16px;"}),C=Object(c.a)(p.Link,{target:"e1eqr9hl3"})({name:"119ej1e",styles:"text-decoration:none;color:#222;padding:0px 16px;display:block;"}),z=Object(c.a)("div",{target:"e1eqr9hl4"})({name:"1movgqp",styles:"font-size:12px;color:#222;display:flex;align-items:center;justify-content:flex-end;width:100%;"});k.propTypes={content:m.a.string.isRequired,objectID:m.a.string.isRequired,slug:m.a.string.isRequired,pageHeading:m.a.string,parentHeading:m.a.string};var L=function(){var t=u.a.useRef(),e=u.a.useState(!1),n=e[0],i=e[1];return u.a.useEffect(function(){function e(e){t.current&&!t.current.contains(e.target)&&i(!1)}return document.addEventListener("mousedown",e),document.addEventListener("touchstart",e),function(){document.removeEventListener("mousedown",e),document.removeEventListener("touchstart",e)}},[t]),Object(l.d)(j.a,{searchClient:w,indexName:"taitocli",root:{Root:I,props:{ref:t}},onSearchStateChange:function(){n||i(!0)}},Object(l.d)(O.a,null),n&&Object(l.d)(T,null,Object(l.d)(y.a,{hitComponent:k}),Object(l.d)(z,null,"Powered by"," ",Object(l.d)("a",{href:"https://www.algolia.com"},Object(l.d)(h.a,{size:16})," Algolia"))))},S=Object(c.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",s.a),P=Object(c.a)(p.Link,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),D=function(){var t={fontWeight:500,borderColor:b.a.primary[500]};return Object(l.d)(S,null,Object(l.d)(P,{to:"/"},Object(l.d)("strong",null,"Taito")," CLI"),Object(l.d)("div",{style:{flex:1}}),Object(l.d)(P,{to:"/docs",activeStyle:t,partiallyActive:!0},"Docs"),Object(l.d)(P,{to:"/tutorial",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(l.d)(P,{to:"/plugins",activeStyle:t},"Plugins"),Object(l.d)(P,{to:"/templates",activeStyle:t},"Templates"),Object(l.d)(P,{to:"/extensions",activeStyle:t},"Extensions"),Object(l.d)("div",{style:{flex:1}}),Object(l.d)(L,null),Object(l.d)("div",null,"Github"))},E=n(177),A=Object(c.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),H=function(){return Object(l.d)(A,null,"Footer")};function N(){var t=o()(["\n    margin-top: 40px;\n  "]);return N=function(){return t},t}var R=Object(c.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),V=Object(c.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",s.d.sm(N())),F=Object(c.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a:not(.autolink-a){color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,i=t.children,o=a()(t,["menu","children"]);return Object(l.d)(R,o,Object(l.d)(V,null,n,Object(l.d)(F,null,i)),Object(l.d)(H,null),Object(l.d)(D,null),Object(l.d)(E.a,null,Object(l.d)(E.a.Item,{to:"/"},"Home"),Object(l.d)(E.a.Item,{to:"/docs"},"Docs"),Object(l.d)(E.a.Item,{to:"/tutorial"},"Tutorial"),Object(l.d)(E.a.Item,{to:"/plugins"},"Plugins"),Object(l.d)(E.a.Item,{to:"/templates"},"Templates"),Object(l.d)(E.a.Item,{to:"/extensions"},"Extensions")))}}}]);
//# sourceMappingURL=component---src-pages-404-js-aaa5658187717b9d535c.js.map