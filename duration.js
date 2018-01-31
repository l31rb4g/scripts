function duration(n) {
    let r = '',
        hours = 0,
        mins = 0,
        secs = n;
    while (secs >= 60) {
        mins = parseInt(secs / 60);
        secs = secs % 60;
    }
    while (mins >= 60) {
        hours = parseInt(mins / 60);
        mins = mins % 60;
    }
    if (hours) {
        if (hours < 10) hours = '0' + hours;
        r += hours + ':';
    } else {
        r += '00:';
    }
    if (mins) {
        if (mins < 10) mins = '0' + mins;
        r += mins + ':';
    } else {
        r += '00:';
    }
    if (secs) {
        if (secs < 10) secs = '0' + secs;
        r += secs;
    } else {
        r += '00';
    }
    return r;
}
