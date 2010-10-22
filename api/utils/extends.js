module.exports = function extends(p) {
    function f() {}
    f.prototype = p;
    return new f();
}