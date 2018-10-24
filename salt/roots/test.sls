pillar test:
  cmd.run:
    - name: touch /pillar-{{ pillar['test value'] }}