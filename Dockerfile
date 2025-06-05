#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps

# Install Tex Live
RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
    texlive-latex-base \
    texlive-extra-utils \
    texlive-latex-extra \
    biber chktex latexmk make python3-pygments python3-pkg-resources \
    texlive-lang-german \
    texlive-fonts-recommended \
    texlive-science

#install extra tools
RUN apt-get -y install gnuplot 
RUN apt-get -y install openssh-client
RUN apt-get -y install inkscape

# install imagemagick and ffmpeg for video creation
RUN apt-get -y install imagemagick ffmpeg
RUN sed -i.bak '/<policy domain="coder"/d' /etc/ImageMagick-6/policy.xml 

# latexindent modules
RUN apt-get install --no-install-recommends -y curl
RUN curl -L http://cpanmin.us | perl - App::cpanminus \
    && cpanm Log::Dispatch::File \
    && cpanm YAML::Tiny \
    && cpanm File::HomeDir \
    && cpanm Unicode::GCString

#Gradio Client for Fishaudio
RUN apt-get -y install python3-pip
RUN pip install --break-system-packages gradio_client

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
