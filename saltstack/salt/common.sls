common environment variables:
 file.append:
    - name: /etc/environment
    - text: CLUSTER_DOMAIN={{ pillar['cluster domain'] }}
