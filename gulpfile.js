const Gulp = require("gulp");
const URL = require("url");
const Cheerio = require("gulp-cheerio");

var tag = "planter-app-20";

Gulp.task("affiliate-links", () => {
    return Gulp.src(["public/posts/**/*.html"])
    .pipe(Cheerio(function($, file) {
        var url;
        $("a").each(function() {
            var a = $(this);
            url = URL.parse(a.attr("href"));
            let searchParams = new URLSearchParams(url.query);
            searchParams.set('tag',tag)
            if(a.attr("href").startsWith("https://www.amazon")) {
               a.attr("href", url.protocol + "//" + url.hostname + url.pathname + "?" + searchParams.toString());
            }
        });
    }))
    .pipe(Gulp.dest(function (file) {
            return file.base;
        }));
});

Gulp.task("build", Gulp.series("affiliate-links"));