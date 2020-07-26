FROM python:3.7-slim
ENV DEBIAN_FRONTEND noninteractive
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

RUN apt update && apt -y install git libgl1-mesa-dev xvfb

# install pyvista
# RUN pip install --no-cache pyviz
RUN pip install --no-cache bokeh
# RUN pip install --no-cache pyviz_comms
RUN pip install --no-cache panel
RUN pip install --no-cache lxml
RUN pip install --no-cache git+git://github.com/pyvista/pyvista@master
RUN pip install --no-cache matplotlib
RUN pip install --no-cache pyct

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
COPY . ${HOME}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

ENV DISPLAY :99.0
ENV PYVISTA_OFF_SCREEN true
ENV PYVISTA_USE_PANEL true
ENV PYVISTA_PLOT_THEME document
# This is needed for Panel - use with cuation!
ENV PYVISTA_AUTO_CLOSE false
RUN which Xvfb
RUN Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
