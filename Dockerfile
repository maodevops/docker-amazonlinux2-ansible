#
# Dockerfile used to build AmazonLinux 2 images for testing Ansible
#

# syntax = docker/dockerfile:1

ARG BASE_IMAGE_TAG=2

FROM amazonlinux:${BASE_IMAGE_TAG}

ENV container=docker

RUN yum -y update ; \
  yum -y install systemd ; \
  cd /lib/systemd/system/sysinit.target.wants/ ; \
  for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i ; done ; \
  rm -f /lib/systemd/system/multi-user.target.wants/* ; \
  rm -f /etc/systemd/system/*.wants/* ; \
  rm -f /lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /lib/systemd/system/basic.target.wants/* ; \
  rm -f /lib/systemd/system/anaconda.target.wants/*

RUN yum clean all ; \
  yum -y autoremove ; \
  rm -rf /var/cache/yum ;

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/lib/systemd/systemd"]
