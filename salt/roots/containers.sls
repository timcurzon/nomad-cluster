# Dont need local containers (yet)

# containers build nginxtest:
#   cmd.run:
#     - cwd: /containers/nginxtest
#     - name: ./build && touch built
#     - unless:
#       - ls built