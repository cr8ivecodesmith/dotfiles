#!/usr/bin/env python3
import argparse
import subprocess

LS_HEADERS = [
    '{{.ID}}',
    '{{.Names}}',
    '{{.Status}}',
]


def list_containers(filter_args=None, id_only=False,
                    show_ports=False, sep=None):
    cmd = 'docker ps'

    headers = LS_HEADERS
    sep = sep or '\t'

    if show_ports:
        headers = LS_HEADERS + ['{{.Ports}}']

    if not id_only:
        cmd += ' -a --format "{}"'.format(
            sep.join([i for i in headers])
        )
    else:
        cmd += ' -aq'

    if filter_args:
        ffmt = '--filter "{}={}"'
        cmd += ' {}'.format(' '.join(
            [ffmt.format(k,v) for k, v in filter_args.items() if v]
        ))

    subprocess.run([cmd], shell=True, check=True)


def main():
    parser = argparse.ArgumentParser()
    parser.description = (
        'List docker containers.'
    )
    parser.add_argument(
        '--id',
        help=(
            'Filter by container\'s ID.'
        ),
        dest='ID_FILTER',
    )
    parser.add_argument(
        '--name',
        help=(
            'Filter by container\'s name.'
        ),
        dest='NAME_FILTER',
    )
    parser.add_argument(
        '--status',
        help=(
            'Filter by one of created, restarting, running, removing, paused, '
            'exited, or dead'
        ),
        dest='STATUS_FILTER',
    )
    parser.add_argument(
        '--show-ports', '-p',
        help=(
            'Display port mappings.'
        ),
        action='store_true',
        dest='SHOW_PORTS',
    )
    parser.add_argument(
        '--quiet', '-q',
        help=(
            'Show ID only.'
        ),
        action='store_true',
        dest='ID_ONLY',
    )
    parser.add_argument(
        '--separator', '-s',
        help=(
            'Set output separator.'
        ),
        dest='SEP',
    )
    args = parser.parse_args()

    filter_args = {
        'id': args.ID_FILTER,
        'name': args.NAME_FILTER,
        'status': args.STATUS_FILTER,
    }

    list_containers(
        filter_args=filter_args,
        show_ports=args.SHOW_PORTS,
        id_only=args.ID_ONLY,
        sep=args.SEP
    )


if __name__ == '__main__':
    main()
