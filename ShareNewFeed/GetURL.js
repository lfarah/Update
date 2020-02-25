//
//  GetURL.js
//  ShareNewFeed
//
//  Created by Lucas Farah on 2/13/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

var GetURL = function() {};
GetURL.prototype = {
    run: function(arguments) {
        var links = document.getElementsByTagName( "link" ),
        filtered = [],
        i = links.length;
       while ( i-- ) {
          links[i].rel === "alternate" &&
          (links[i].type === "application/rss+xml" || links[i].type === "application/rss") && filtered.push( links[i].href );
       }
       arguments.completionFunction({"Feeds": filtered, "URL": document.URL});
    }
};
var ExtensionPreprocessingJS = new GetURL;
