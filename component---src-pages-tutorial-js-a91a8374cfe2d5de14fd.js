(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{174:function(t,e,n){"use strict";n.r(e),n.d(e,"query",function(){return c});var r=n(1),o=(n(0),n(67)),i=n(185),a=n(183);e.default=function(t){var e=t.data,n=Object(o.c)(e,"data")[0];return Object(r.d)(i.a,null,Object(r.d)(a.a,null),Object(r.d)("div",{dangerouslySetInnerHTML:{__html:n.html}}))};var c="2324460314"},177:function(t,e,n){"use strict";var r=n(20),o=n.n(r),i=n(176),a=n(67);function c(){var t=o()(["",""]);return c=function(){return t},t}function u(){var t=o()(["",""]);return u=function(){return t},t}function d(){var t=o()(["",""]);return d=function(){return t},t}var l=function(t){switch(t){case"horizontal":return"width";case"vertical":return"height";default:return"width"}},s=function(t,e){var n=e.dir,r=e.amount||t.amount||16;return l(n||t.dir)+": "+r+"px;"},p=Object(i.a)("div",{target:"eemuqzb0"})("height:0px;",function(t){return function(t){var e=t.amount||16;return l(t.dir)+": "+e+"px;"}(t)}," ",function(t){return t.sm&&a.d.sm(d(),s(t,t.sm))}," ",function(t){return t.md&&a.d.md(u(),s(t,t.md))}," ",function(t){return t.lg&&a.d.lg(c(),s(t,t.lg))});e.a=p},180:function(t,e,n){"use strict";var r=n(176),o=n(1),i=n(0),a=n.n(i),c=n(179),u=n(68),d=n(2),l=n.n(d),s=n(67),p=n(13).b?Math.min(360,.8*window.innerWidth):360,b=3,f=2,m=1,g={buttonPosition:l.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:l.a.node},x=function(t){var e=t.buttonPosition,n=t.buttonIcon,r=t.children,i=a.a.useState(!1),d=i[0],l=i[1];return Object(o.d)(a.a.Fragment,null,Object(o.d)(k,{onClick:function(){return l(!0)},position:e},n||Object(o.d)(c.b,null)),Object(o.d)(h,{isVisible:d,onClick:function(){return l(!1)}}),Object(o.d)(j,{isOpen:d},a.a.Children.map(r,function(t,e){return a.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,l(!1),void setTimeout(function(){return Object(u.navigate)(e)},400);var e}})})))},h=Object(r.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",f,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",s.e,";"),j=Object(r.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",b,";top:0;bottom:0;left:0;overflow-y:auto;width:",p,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-p-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",s.e,";"),O=Object(r.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),v={name:"vced1a",styles:"top:8px;left:8px;"},y={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(r.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",m,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&v}," ",function(t){return"top-right"===t.position&&y}," ",function(t){return"bottom-right"===t.position&&w}," ",s.e,";");x.Item=O,x.propTypes=g,x.defaultProps={buttonPosition:"top-right"},e.a=x},183:function(t,e,n){"use strict";var r=n(1),o=n(184),i=(n(0),n(191)),a=n(2),c=n.n(a),u=n(68),d=function(t){var e=t.title,n=t.description;return Object(r.d)(u.StaticQuery,{query:l,render:function(t){var o=t.site.siteMetadata,a=o.defaultTitle,c=o.defaultDescription,u={title:e||a,description:n||c};return Object(r.d)(i.Helmet,{title:u.title},Object(r.d)("meta",{name:"description",content:u.description}),u.title&&Object(r.d)("meta",{property:"og:title",content:u.title}),u.description&&Object(r.d)("meta",{property:"og:description",content:u.description}),u.title&&Object(r.d)("meta",{name:"twitter:title",content:u.title}),u.description&&Object(r.d)("meta",{name:"twitter:description",content:u.description}))},data:o})};e.a=d,d.propTypes={title:c.a.string,description:c.a.string},d.defaultProps={title:null,description:null};var l="1858091358"},184:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},185:function(t,e,n){"use strict";var r=n(20),o=n.n(r),i=n(32),a=n.n(i),c=n(176),u=n(1),d=n(0),l=n.n(d),s=n(67),p=n(68),b=n(181),f=n(33),m=n(177),g=n(189),x=n.n(g),h=n(545),j=n(547),O=n(544),v=n(47),y=n.n(v),w=n(543),k=n(179),z=Object(c.a)("form",{target:"epkufyz0"})({name:"1sbsy6p",styles:"display:flex;align-items:center;color:#fff;padding:6px 8px;border-radius:4px;background-color:rgba(0,0,0,0.2);"}),I=Object(c.a)("input",{target:"epkufyz1"})({name:"1dalrlu",styles:"margin-left:8px;background:transparent;border:none;outline:none;font-size:14px;color:#fff;&::placeholder{color:#ccc;}"}),S=Object(w.a)(function(t){var e=t.refine,n=a()(t,["refine"]);return Object(u.d)(z,null,Object(u.d)(k.c,null),Object(u.d)(I,y()({type:"text",placeholder:"Search","aria-label":"Search",onChange:function(t){return e(t.target.value)}},n)))}),T=n(2),C=n.n(T),L=n(546),q=function(t){var e=t.hit,n=e.objectID,r=e.slug,o=e.pageHeading,i=e.parentHeading,a=i?function(t,e){var n=t.length-1;return("/"===t[n]?t.substr(0,n):t)+"#"+Object(s.g)(e)}(r,i):r;return Object(u.d)(P,{to:a,key:n},Object(u.d)(E,null,o),Object(u.d)(L.a,{hit:e,attribute:"content",tagName:"mark"}))},P=Object(c.a)(p.Link,{target:"e1tbt02d0"})("text-decoration:none;color:#222;display:flex;flex-direction:column;border-bottom:1px solid ",function(t){return t.theme.grey[300]},";padding-bottom:8px;&:hover{background-color:",function(t){return t.theme.primary[100]},";}"),E=Object(c.a)("div",{target:"e1tbt02d1"})("padding:3px 6px;background-color:",function(t){return t.theme.primary[500]},";color:#fff;font-weight:700;font-size:14px;width:fit-content;border-radius:4px;margin-bottom:4px;");q.propTypes={content:C.a.string.isRequired,objectID:C.a.string.isRequired,slug:C.a.string.isRequired,pageHeading:C.a.string,parentHeading:C.a.string};var H=q,D=x()("KG2PVUXA5L","c744101a7faa04ad219b22127a719755"),A=Object(O.a)(function(t){var e=t.searchState,n=t.searchResults,r=t.children;return n&&n.nbHits?r:"No results for "+e.query}),R=Object(c.a)("div",{target:"e1but0ij0"})({name:"7boy05",styles:"position:relative;display:flex;align-items:center;"}),M=Object(c.a)("div",{target:"e1but0ij1"})({name:"naeal3",styles:"position:absolute;top:36px;right:0px;width:400px;max-height:400px;overflow-y:auto;background-color:#fff;border-radius:4px;padding:12px;border:4px solid #fff;box-shadow:0px 4px 24px rgba(0,0,0,0.4);ul{list-style:none !important;padding:0 !important;margin:0 !important;li{margin-bottom:8px;}}"}),N=Object(c.a)("div",{target:"e1but0ij2"})({name:"1movgqp",styles:"font-size:12px;color:#222;display:flex;align-items:center;justify-content:flex-end;width:100%;"}),V=function(){var t=l.a.useRef(),e=l.a.useState(!1),n=e[0],r=e[1],o=l.a.useState(""),i=o[0],a=o[1];return l.a.useEffect(function(){function e(e){t.current&&!t.current.contains(e.target)&&r(!1)}return document.addEventListener("mousedown",e),document.addEventListener("touchstart",e),function(){document.removeEventListener("mousedown",e),document.removeEventListener("touchstart",e)}},[t]),Object(u.d)(h.a,{searchClient:D,indexName:"taitocli",root:{Root:R,props:{ref:t}},onSearchStateChange:function(t){var e=t.query;return a(e)}},Object(u.d)(S,{onFocus:function(){return r(!0)}}),n&&!!i&&Object(u.d)(M,null,Object(u.d)(A,null,Object(u.d)(j.a,{hitComponent:H})),Object(u.d)(N,null,"Powered by",Object(u.d)(m.a,{amount:4}),Object(u.d)(b.a,{size:16}),Object(u.d)(m.a,{amount:4}),Object(u.d)("a",{href:"https://www.algolia.com"},"Algolia"))))},F=Object(c.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;align-items:center;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;padding:0px 16px;",s.a),J=Object(c.a)(p.Link,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),W=function(){var t={fontWeight:500,borderColor:f.a.primary[500]};return Object(u.d)(F,null,Object(u.d)(J,{to:"/"},Object(u.d)("strong",null,"Taito")," CLI"),Object(u.d)("div",{style:{flex:1}}),Object(u.d)(J,{to:"/docs",activeStyle:t,partiallyActive:!0},"Docs"),Object(u.d)(J,{to:"/tutorial",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(u.d)(J,{to:"/plugins",activeStyle:t},"Plugins"),Object(u.d)(J,{to:"/templates",activeStyle:t},"Templates"),Object(u.d)(J,{to:"/extensions",activeStyle:t},"Extensions"),Object(u.d)("div",{style:{flex:1}}),Object(u.d)(V,null),Object(u.d)(m.a,null),Object(u.d)(b.b,{color:"#fff",size:24}))},X=n(180),_=Object(c.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),G=function(){return Object(u.d)(_,null,"Footer")};function K(){var t=o()(["\n    margin-top: 40px;\n  "]);return K=function(){return t},t}var Q=Object(c.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),U=Object(c.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",s.d.sm(K())),Y=Object(c.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a:not(.autolink-a){color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,r=t.children,o=a()(t,["menu","children"]);return Object(u.d)(Q,o,Object(u.d)(U,null,n,Object(u.d)(Y,null,r)),Object(u.d)(G,null),Object(u.d)(W,null),Object(u.d)(X.a,null,Object(u.d)(X.a.Item,{to:"/"},"Home"),Object(u.d)(X.a.Item,{to:"/docs"},"Docs"),Object(u.d)(X.a.Item,{to:"/tutorial"},"Tutorial"),Object(u.d)(X.a.Item,{to:"/plugins"},"Plugins"),Object(u.d)(X.a.Item,{to:"/templates"},"Templates"),Object(u.d)(X.a.Item,{to:"/extensions"},"Extensions")))}}}]);
//# sourceMappingURL=component---src-pages-tutorial-js-a91a8374cfe2d5de14fd.js.map