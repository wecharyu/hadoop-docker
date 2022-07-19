FROM wechar/cluster-base AS base

FROM mysql:5.7-debian

# install basic develop tools for contianer
RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
   openssh-server rsync grsync curl gnupg sudo \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

# copy ssh keys to surpport ssh login other hosts
COPY --from=base /root/.ssh/id_rsa /root/.ssh/id_rsa
COPY --from=base /root/.ssh/authorized_keys /root/.ssh/authorized_keys
