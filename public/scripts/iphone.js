function doScroll() { 
    if (window.pageYOffset === 0) { 
        window.scrollTo(0,1);
    }
}

window.addEventListener('load', function () {
        setTimeout(doScroll, 100);
        }, false);

window.onorientationchange = function() {
    setTimeout(doScroll, 100);
};
