(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{174:function(t,e,n){"use strict";n.r(e),n.d(e,"query",function(){return c});var r=n(1),o=(n(0),n(67)),i=n(186),a=n(183);e.default=function(t){var e=t.data,n=Object(o.c)(e,"data")[0];return Object(r.d)(i.a,null,Object(r.d)(a.a,null),Object(r.d)("div",{dangerouslySetInnerHTML:{__html:n.html}}))};var c="2324460314"},177:function(t,e,n){"use strict";var r=n(20),o=n.n(r),i=n(176),a=n(67);function c(){var t=o()(["",""]);return c=function(){return t},t}function u(){var t=o()(["",""]);return u=function(){return t},t}function d(){var t=o()(["",""]);return d=function(){return t},t}var l=function(t){switch(t){case"horizontal":return"width";case"vertical":return"height";default:return"width"}},p=function(t,e){var n=e.dir,r=e.amount||t.amount||16;return l(n||t.dir)+": "+r+"px;"},s=Object(i.a)("div",{target:"eemuqzb0"})("height:0px;",function(t){return function(t){var e=t.amount||16;return l(t.dir)+": "+e+"px;"}(t)}," ",function(t){return t.sm&&a.d.sm(d(),p(t,t.sm))}," ",function(t){return t.md&&a.d.md(u(),p(t,t.md))}," ",function(t){return t.lg&&a.d.lg(c(),p(t,t.lg))});e.a=s},180:function(t,e,n){"use strict";var r=n(176),o=n(1),i=n(0),a=n.n(i),c=n(179),u=n(68),d=n(2),l=n.n(d),p=n(67),s=n(13).b?Math.min(360,.8*window.innerWidth):360,f=3,b=2,m=1,g={buttonPosition:l.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:l.a.node},x=function(t){var e=t.buttonPosition,n=t.buttonIcon,r=t.children,i=a.a.useState(!1),d=i[0],l=i[1];return Object(o.d)(a.a.Fragment,null,Object(o.d)(k,{onClick:function(){return l(!0)},position:e},n||Object(o.d)(c.b,null)),Object(o.d)(h,{isVisible:d,onClick:function(){return l(!1)}}),Object(o.d)(j,{isOpen:d},a.a.Children.map(r,function(t,e){return a.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,l(!1),void setTimeout(function(){return Object(u.navigate)(e)},400);var e}})})))},h=Object(r.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",b,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",p.e,";"),j=Object(r.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",f,";top:0;bottom:0;left:0;overflow-y:auto;width:",s,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-s-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",p.e,";"),O=Object(r.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),v={name:"vced1a",styles:"top:8px;left:8px;"},y={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(r.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",m,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&v}," ",function(t){return"top-right"===t.position&&y}," ",function(t){return"bottom-right"===t.position&&w}," ",p.e,";");x.Item=O,x.propTypes=g,x.defaultProps={buttonPosition:"top-right"},e.a=x},183:function(t,e,n){"use strict";var r=n(1),o=n(184),i=(n(0),n(192)),a=n(2),c=n.n(a),u=n(68),d=function(t){var e=t.title,n=t.description;return Object(r.d)(u.StaticQuery,{query:l,render:function(t){var o=t.site.siteMetadata,a=o.defaultTitle,c=o.defaultDescription,u={title:e||a,description:n||c};return Object(r.d)(i.Helmet,{title:u.title},Object(r.d)("meta",{name:"description",content:u.description}),u.title&&Object(r.d)("meta",{property:"og:title",content:u.title}),u.description&&Object(r.d)("meta",{property:"og:description",content:u.description}),u.title&&Object(r.d)("meta",{name:"twitter:title",content:u.title}),u.description&&Object(r.d)("meta",{name:"twitter:description",content:u.description}))},data:o})};e.a=d,d.propTypes={title:c.a.string,description:c.a.string},d.defaultProps={title:null,description:null};var l="1858091358"},184:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},185:function(t,e,n){"use strict";var r=n(176),o=n(1),i=n(0),a=n.n(i),c=n(67),u=n(68),d=n(181),l=n(33),p=n(177),s=n(20),f=n.n(s),b=n(190),m=n.n(b),g=n(546),x=n(548),h=n(545),j=n(47),O=n.n(j),v=n(32),y=n.n(v),w=n(544),k=n(179);function z(){var t=f()(["\n    font-size: 16px;\n    color: ",";\n  "]);return z=function(){return t},t}function I(){var t=f()(["\n    width: 100%;\n    padding: 0px 8px;\n    height: 40px;\n    border: 1px solid ",";\n    color: ",";\n    background-color: ",";\n  "]);return I=function(){return t},t}var S=Object(r.a)("form",{target:"epkufyz0"})("display:flex;align-items:center;color:#fff;padding:6px 8px;border-radius:4px;background-color:rgba(0,0,0,0.2);",function(t){return c.d.sm(I(),t.theme.grey[500],t.theme.black,t.theme.grey[100])}),T=Object(r.a)("input",{target:"epkufyz1"})("margin-left:8px;background:transparent;border:none;outline:none;font-size:14px;color:#fff;",function(t){return c.d.sm(z(),t.theme.black)}," &::placeholder{color:#ccc;}"),C=Object(w.a)(function(t){var e=t.refine,n=y()(t,["refine"]);return Object(o.d)(S,null,Object(o.d)(k.c,null),Object(o.d)(T,O()({type:"text",placeholder:"Search","aria-label":"Search",onChange:function(t){return e(t.target.value)}},n)))}),L=n(2),q=n.n(L),H=n(547),P=function(t){var e=t.hit,n=e.objectID,r=e.slug,i=e.pageHeading,a=e.parentHeading,u=a?function(t,e){var n=t.length-1;return("/"===t[n]?t.substr(0,n):t)+"#"+Object(c.g)(e)}(r,a):r;return Object(o.d)(E,{to:u,key:n},Object(o.d)(D,null,i),Object(o.d)(H.a,{hit:e,attribute:"content",tagName:"mark"}))},E=Object(r.a)(u.Link,{target:"e1tbt02d0"})("text-decoration:none;color:#222;display:flex;flex-direction:column;border-bottom:1px solid ",function(t){return t.theme.grey[300]},";padding-bottom:8px;&:hover{background-color:",function(t){return t.theme.primary[100]},";}"),D=Object(r.a)("div",{target:"e1tbt02d1"})("padding:3px 6px;background-color:",function(t){return t.theme.primary[500]},";color:#fff;font-weight:700;font-size:14px;width:fit-content;border-radius:4px;margin-bottom:4px;");P.propTypes={content:q.a.string.isRequired,objectID:q.a.string.isRequired,slug:q.a.string.isRequired,pageHeading:q.a.string,parentHeading:q.a.string};var A=P;function M(){var t=f()(["\n    top: 48px;\n    width: 100%;\n    max-height: calc(80vh - 56px);\n  "]);return M=function(){return t},t}function R(){var t=f()(["\n    width: 100%;\n  "]);return R=function(){return t},t}var N=m()("KG2PVUXA5L","c744101a7faa04ad219b22127a719755"),V=Object(h.a)(function(t){var e=t.searchState,n=t.searchResults,r=t.children;return n&&n.nbHits?r:"No results for "+e.query}),_=Object(r.a)("div",{target:"e1but0ij0"})("position:relative;display:flex;align-items:center;",c.d.sm(R())),F=Object(r.a)("div",{target:"e1but0ij1"})("position:absolute;top:36px;right:0px;width:400px;max-height:400px;overflow-y:auto;background-color:#fff;border-radius:4px;padding:12px;border:4px solid #fff;box-shadow:0px 4px 24px rgba(0,0,0,0.4);",c.d.sm(M())," ul{list-style:none !important;padding:0 !important;margin:0 !important;li{margin-bottom:8px;}}"),J=Object(r.a)("div",{target:"e1but0ij2"})({name:"1movgqp",styles:"font-size:12px;color:#222;display:flex;align-items:center;justify-content:flex-end;width:100%;"}),U=function(){var t=a.a.useRef(),e=a.a.useState(!1),n=e[0],r=e[1],i=a.a.useState(""),c=i[0],u=i[1];return a.a.useEffect(function(){function e(e){t.current&&!t.current.contains(e.target)&&r(!1)}return document.addEventListener("mousedown",e),document.addEventListener("touchstart",e),function(){document.removeEventListener("mousedown",e),document.removeEventListener("touchstart",e)}},[t]),Object(o.d)(g.a,{searchClient:N,indexName:"taitocli",root:{Root:_,props:{ref:t}},onSearchStateChange:function(t){var e=t.query;return u(e)}},Object(o.d)(C,{onFocus:function(){return r(!0)}}),n&&!!c&&Object(o.d)(F,null,Object(o.d)(V,null,Object(o.d)(x.a,{hitComponent:A})),Object(o.d)(J,null,"Powered by",Object(o.d)(p.a,{amount:4}),Object(o.d)(d.a,{size:16}),Object(o.d)(p.a,{amount:4}),Object(o.d)("a",{href:"https://www.algolia.com"},"Algolia"))))},W=Object(r.a)("nav",{target:"enydrj50"})("position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",c.a),X=Object(r.a)("nav",{target:"enydrj51"})({name:"bd405m",styles:"display:flex;flex-direction:row;align-items:center;padding:0px 16px;"}),G=Object(r.a)(u.Link,{target:"enydrj52"})("height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[900]},";}"),K=function(){var t={fontWeight:500,borderColor:l.a.primary[500]};return Object(o.d)(W,null,Object(o.d)(X,null,Object(o.d)(G,{to:"/"},Object(o.d)("strong",null,"Taito")," CLI"),Object(o.d)(p.a,{amount:64}),Object(o.d)(G,{to:"/docs",activeStyle:t,partiallyActive:!0},"Docs"),Object(o.d)(p.a,{amount:32}),Object(o.d)(G,{to:"/tutorial",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(o.d)(p.a,{amount:32}),Object(o.d)(G,{to:"/plugins",activeStyle:t},"Plugins"),Object(o.d)(p.a,{amount:32}),Object(o.d)(G,{to:"/templates",activeStyle:t},"Templates"),Object(o.d)(p.a,{amount:32}),Object(o.d)(G,{to:"/extensions",activeStyle:t},"Extensions"),Object(o.d)("div",{style:{flex:1}}),Object(o.d)(U,null),Object(o.d)(p.a,null),Object(o.d)("a",{href:"https://github.com/TaitoUnited/taito-cli",target:"__blank",rel:"noopener noreferrer"},Object(o.d)(d.b,{color:"#fff",size:24}))))},Q=n(180),Y=Object(r.a)("div",{target:"em0ofjo0"})("position:fixed;top:0;left:0;right:0;height:64px;display:flex;align-items:center;padding:0px 64px 0px 16px;background-color:",function(t){return t.transparent?"transparent":"#fff"},";",c.e);e.a=function(t){var e=t.isHome;return Object(o.d)(a.a.Fragment,null,Object(o.d)(K,null),Object(o.d)(Y,{transparent:!!e},Object(o.d)(U,null)),Object(o.d)(Q.a,null,Object(o.d)(Q.a.Item,{to:"/"},"Home"),Object(o.d)(Q.a.Item,{to:"/docs"},"Docs"),Object(o.d)(Q.a.Item,{to:"/tutorial"},"Tutorial"),Object(o.d)(Q.a.Item,{to:"/plugins"},"Plugins"),Object(o.d)(Q.a.Item,{to:"/templates"},"Templates"),Object(o.d)(Q.a.Item,{to:"/extensions"},"Extensions")))}},186:function(t,e,n){"use strict";var r=n(20),o=n.n(r),i=n(32),a=n.n(i),c=n(176),u=n(1),d=(n(0),n(67)),l=n(185);function p(){var t=o()(["\n    padding-left: 0px;\n    margin-top: 54px;\n  "]);return p=function(){return t},t}var s=Object(c.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),f=Object(c.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;padding-left:",function(t){return t.hasMenu?320:0},"px;",d.d.sm(p())),b=Object(c.a)("div",{target:"e52t6hk2"})({name:"fpwd92",styles:"position:fixed;top:50px;left:0px;height:calc(100vh - 50px);overflow-y:auto;"}),m=Object(c.a)("div",{target:"e52t6hk3"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a:not(.autolink-a){color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,r=t.children,o=a()(t,["menu","children"]);return Object(u.d)(s,o,Object(u.d)(f,{hasMenu:!!n},n&&Object(u.d)(b,null,n),Object(u.d)(m,null,r)),Object(u.d)(l.a,null))}}}]);
//# sourceMappingURL=component---src-pages-tutorial-js-9b1de1d985984dc2ed6d.js.map