FROM unocha/alpine-base-s6-python3

RUN apk -U --no-progress upgrade && \
    apk add --no-progress --no-cache --virtual \
        .pillow-deps \
        musl-dev \
        jpeg-dev \
        zlib-dev \
        freetype-dev \
        lcms2-dev \
        openjpeg-dev \
        tiff-dev \
        tk-dev \
        postgresql-dev \
        python3-dev \
        gcc \
        libjpeg-turbo \
        shadow \
        tcl-dev && \
    pip install \
        watchdog \
        gunicorn \
        psycopg2-binary \
        https://github.com/spl0k/supysonic/archive/master.tar.gz && \
    apk add --no-cache --virtual .media \
        ffmpeg \
        flac \
        mpg123 \
        vorbis-tools \
        lame && \
    apk --no-progress del gcc musl-dev zlib-dev jpeg-dev && \
    mkdir /app && \
    wget -O /app/app.py https://raw.githubusercontent.com/spl0k/supysonic/master/cgi-bin/supysonic.wsgi && \
    rm -rf /tmp/* /root/.cache

ADD root/ /

EXPOSE 8000
VOLUME /config /media

