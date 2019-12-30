{%- from "freeipa/map.jinja" import client,server with context %}

include:
- openssh.server

sssd_service:
  service.running:
    - name: sssd
    - watch_in:
      - service: sshd    
    - watch:
      - file: sssd_conf

sssd_conf:
  file.managed:
    - name: {{ client.sssd_conf }}
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://freeipa/files/sssd.conf
    - makedirs: True

ldap_conf:
  file.managed:
    - name: {{ client.ldap_conf }}
    - template: jinja
    - source: salt://freeipa/files/ldap.conf
    - makedirs: True

{%- if grains.os_family == 'RedHat' %}
ldap_conf_nss:
  file.absent:
    - name: /etc/ldap.conf

nss_packages_absent:
  pkg.removed:
    - names: ['nss-pam-ldapd', 'nslcd']
    - watch_in:
      - file: ldap_conf_nss
{%- endif %}


