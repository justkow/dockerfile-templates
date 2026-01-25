FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server git ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/run/sshd

RUN useradd -m -d /home/git -s /usr/bin/git-shell git \
 && mkdir -p /home/git/.ssh /home/git/repos \
 && chown -R git:git /home/git \
 && chmod 700 /home/git/.ssh

EXPOSE 22

CMD ["/bin/sh","-lc","ssh-keygen -A >/dev/null 2>&1 || true; exec /usr/sbin/sshd -D -e"]
