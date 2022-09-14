FROM rocker/shiny:4.0.5
LABEL authors="Nicolas Pillon"
ARG REPO="NicoPillon/MetaMEx"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    apt-get install -y git && \
    apt-get install -y git libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages(c("shinyjs", "shinycssloaders", "rmarkdown"))'

RUN Rscript -e 'install.packages(c("ggplot2", "gplots", "ggpubr", "ggprism", "ggfortify"))'

RUN Rscript -e 'install.packages(c("dplyr", "DT", "stringr", "scales", "rvest", "feather"))'

RUN Rscript -e 'install.packages(c("forestplot", "metafor"))'

RUN cd /srv/shiny-server/ && \
    git clone https://github.com/${REPO}.git app && \
    sudo chown -R shiny:shiny /srv/shiny-server/app

COPY shiny-customized.config /etc/shiny-server/shiny-server.conf

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
