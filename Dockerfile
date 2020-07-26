FROM python:3.7-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

# install pyvista
RUN apt update && apt -y install git libgl1-mesa-dev xvfb
RUN pip install --no-cache git+git://github.com/pyvista/pyvista@master
ENV DISPLAY :99.0
ENV PYVISTA_OFF_SCREEN true
ENV PYVISTA_USE_PANEL true
ENV PYVISTA_PLOT_THEME document
# This is needed for Panel - use with cuation!
ENV PYVISTA_AUTO_CLOSE false
RUN which Xvfb
RUN Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
RUN sleep 3
RUN exec "$@"

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
