(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{172:function(t,e,n){"use strict";n.r(e),n.d(e,"query",function(){return c});var i=n(1),o=(n(0),n(66)),r=n(178),a=n(176);e.default=function(t){var e=t.data,n=Object(o.c)(e,"data")[0];return Object(i.d)(r.a,null,Object(i.d)(a.a,null),Object(i.d)("div",{dangerouslySetInnerHTML:{__html:n.html}}))};var c="2324460314"},175:function(t,e,n){"use strict";var i=n(174),o=n(1),r=n(0),a=n.n(r),c=n(179),l=n(67),d=n(2),u=n.n(d),p=n(66),s=n(13).b?Math.min(360,.8*window.innerWidth):360,b=3,f=2,m=1,x={buttonPosition:u.a.oneOf(["top-left","bottom-right","top-right"]),buttonIcon:u.a.node},g=function(t){var e=t.buttonPosition,n=t.buttonIcon,i=t.children,r=a.a.useState(!1),d=r[0],u=r[1];return Object(o.d)(a.a.Fragment,null,Object(o.d)(k,{onClick:function(){return u(!0)},position:e},n||Object(o.d)(c.b,null)),Object(o.d)(h,{isVisible:d,onClick:function(){return u(!1)}}),Object(o.d)(j,{isOpen:d},a.a.Children.map(i,function(t,e){return a.a.cloneElement(t,{key:e,onClick:function(){return e=t.props.to,u(!1),void setTimeout(function(){return Object(l.navigate)(e)},400);var e}})})))},h=Object(i.a)("div",{target:"e79nuc60"})("position:fixed;top:0;bottom:0;left:0;right:0;background-color:rgba(0,0,0,0.4);z-index:",f,";transition:opacity 0.3s ease-in;opacity:",function(t){return t.isVisible?1:0},";pointer-events:",function(t){return t.isVisible?"auto":"none"},";",p.e,";"),j=Object(i.a)("div",{target:"e79nuc61"})("position:fixed;z-index:",b,";top:0;bottom:0;left:0;overflow-y:auto;width:",s,"px;z-index:100;display:flex;flex-direction:column;box-shadow:0px 0px 12px rgba(0,0,0,0.5);will-change:transform;transform:translateX(",function(t){return t.isOpen?0:-s-10},"px);transition:transform ",400,"ms cubic-bezier(0.2,0.71,0.14,0.91);background-color:#fff;",p.e,";"),O=Object(i.a)("div",{target:"e79nuc62"})("padding:16px;position:relative;&:active{background-color:",function(t){return t.theme.primary[100]},";}&::before{content:'';display:",function(t){return t.isActive?"block":"none"},";position:absolute;left:-5px;top:50%;transform:translateY(-50%);width:12px;height:8px;background-color:",function(t){return t.theme.primary[500]},";border-radius:99px;}"),y={name:"vced1a",styles:"top:8px;left:8px;"},v={name:"1inwuj9",styles:"top:8px;right:8px;"},w={name:"1ic4uk8",styles:"bottom:24px;right:8px;"},k=Object(i.a)("button",{target:"e79nuc63"})("position:fixed;z-index:",m,";border:none;padding:0;color:",function(t){return t.theme.primary[500]},";background-color:#fff;border-radius:50%;height:48px;width:48px;display:flex;justify-content:center;align-items:center;outline:none;opacity:1;transition:opacity 0.2s ease;font-size:24px;box-shadow:0px 2px 8px rgba(0,0,0,0.2);&:active{opacity:0.7;}",function(t){return"top-left"===t.position&&y}," ",function(t){return"top-right"===t.position&&v}," ",function(t){return"bottom-right"===t.position&&w}," ",p.e,";");g.Item=O,g.propTypes=x,g.defaultProps={buttonPosition:"top-right"},e.a=g},176:function(t,e,n){"use strict";var i=n(1),o=n(177),r=(n(0),n(180)),a=n(2),c=n.n(a),l=n(67),d=function(t){var e=t.title,n=t.description;return Object(i.d)(l.StaticQuery,{query:u,render:function(t){var o=t.site.siteMetadata,a=o.defaultTitle,c=o.defaultDescription,l={title:e||a,description:n||c};return Object(i.d)(r.Helmet,{title:l.title},Object(i.d)("meta",{name:"description",content:l.description}),l.title&&Object(i.d)("meta",{property:"og:title",content:l.title}),l.description&&Object(i.d)("meta",{property:"og:description",content:l.description}),l.title&&Object(i.d)("meta",{name:"twitter:title",content:l.title}),l.description&&Object(i.d)("meta",{name:"twitter:description",content:l.description}))},data:o})};e.a=d,d.propTypes={title:c.a.string,description:c.a.string},d.defaultProps={title:null,description:null};var u="1858091358"},177:function(t){t.exports={data:{site:{siteMetadata:{defaultTitle:"Taito CLI",defaultDescription:"Taito CLI - An extensible toolkit for DevOps and NoOps."}}}}},178:function(t,e,n){"use strict";var i=n(18),o=n.n(i),r=n(31),a=n.n(r),c=n(174),l=n(1),d=(n(0),n(66)),u=n(67),p=n(32),s=Object(c.a)("nav",{target:"enydrj50"})("display:flex;flex-direction:row;position:fixed;top:0;left:0;right:0;background-color:",function(t){return t.theme.primary[700]},";z-index:1;",d.a),b=Object(c.a)(u.Link,{target:"enydrj51"})("flex:1;height:50px;display:flex;justify-content:center;align-items:center;text-decoration:none;color:#fff;border-bottom:4px solid ",function(t){return t.theme.primary[700]},";position:relative;&:hover{border-bottom:4px solid ",function(t){return t.theme.primary[500]},";}"),f=function(){var t={fontWeight:500,borderColor:p.a.primary[500]};return Object(l.d)(s,null,Object(l.d)(b,{to:"/"},Object(l.d)("strong",null,"Taito")," CLI"),Object(l.d)("div",{style:{flex:1}}),Object(l.d)(b,{to:"/docs",activeStyle:t,partiallyActive:!0},"Docs"),Object(l.d)(b,{to:"/tutorial",activeStyle:t,partiallyActive:!0},"Tutorial"),Object(l.d)(b,{to:"/plugins",activeStyle:t},"Plugins"),Object(l.d)(b,{to:"/templates",activeStyle:t},"Templates"),Object(l.d)(b,{to:"/extensions",activeStyle:t},"Extensions"),Object(l.d)("div",{style:{flex:1}}),Object(l.d)("div",null,"Search"),Object(l.d)("div",null,"Github lin"))},m=n(175),x=Object(c.a)("div",{target:"e1bnvro20"})({name:"1kasifg",styles:"width:100%;height:200px;background-color:#f5f5f5;padding:32px;"}),g=function(){return Object(l.d)(x,null,"Footer")};function h(){var t=o()(["\n    margin-top: 40px;\n  "]);return h=function(){return t},t}var j=Object(c.a)("div",{target:"e52t6hk0"})({name:"rywwip",styles:"width:100%;min-height:100vh;display:flex;flex-direction:column;"}),O=Object(c.a)("div",{target:"e52t6hk1"})("display:flex;flex-direction:row;width:100%;overflow-x:hidden;margin-top:50px;",d.d.sm(h())),y=Object(c.a)("div",{target:"e52t6hk2"})("flex:1;width:100%;padding:16px;max-width:900px;margin:0px auto;a:not(.autolink-a){color:",function(t){return t.theme.primary[800]},";background-color:",function(t){return t.theme.primary[100]},";border-bottom:1px solid rgba(0,0,0,0.2);text-decoration:none;&:hover{background-color:",function(t){return t.theme.primary[200]},";}}hr{margin-top:24px;margin-bottom:24px;border:none;height:1px;background-color:",function(t){return t.theme.grey[300]},";}ul{list-style:disc;padding-left:24px;}ul > li{margin-top:8px;}blockquote{margin:0;padding:8px 16px;background-color:",function(t){return t.theme.primary[100]},";border-left:8px solid ",function(t){return t.theme.primary[500]},";color:",function(t){return t.theme.primary[700]},";border-radius:2px;}");e.a=function(t){var e=t.menu,n=void 0===e?null:e,i=t.children,o=a()(t,["menu","children"]);return Object(l.d)(j,o,Object(l.d)(O,null,n,Object(l.d)(y,null,i)),Object(l.d)(g,null),Object(l.d)(f,null),Object(l.d)(m.a,null,Object(l.d)(m.a.Item,{to:"/"},"Home"),Object(l.d)(m.a.Item,{to:"/docs"},"Docs"),Object(l.d)(m.a.Item,{to:"/tutorial"},"Tutorial"),Object(l.d)(m.a.Item,{to:"/plugins"},"Plugins"),Object(l.d)(m.a.Item,{to:"/templates"},"Templates"),Object(l.d)(m.a.Item,{to:"/extensions"},"Extensions")))}}}]);
//# sourceMappingURL=component---src-pages-tutorial-js-63b07f8707ac4a473fcb.js.map