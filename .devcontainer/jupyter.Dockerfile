FROM continuumio/miniconda3

RUN conda update -n base -c defaults conda
RUN conda init bash
RUN /bin/bash -c "source /root/.bashrc \
    && conda create -n db-jlab python=3.7 \
    && conda activate db-jlab \
    && pip install --upgrade databrickslabs-jupyterlab==2.0.0 \
    && dj -b"

CMD [ "sleep", "infinity" ]