#!/usr/bin/env python3
import argparse
import subprocess


def list_containers(filter_args=None, id_only=False, command_only=False):
    cmd = 'docker ps'
    out_fmt = '--format "{{.ID}}\t{{.Names}}\t{{.Status}}"'

    if not id_only:
        cmd += ' -a {}'.format(out_fmt)
    else:
        cmd += ' -aq'

    if filter_args:
        ffmt = '--filter "{}={}"'
        cmd += ' {}'.format(' '.join(
            [ffmt.format(k,v) for k, v in filter_args.items() if v]
        ))

    if command_only:
        return cmd
    else:
        subprocess.run([cmd], shell=True, check=True)


def delete_containers(list_cmd):
    cmd = '{} | xargs docker rm -f'.format(list_cmd)
    subprocess.run([cmd], shell=True)


def main():
    parser = argparse.ArgumentParser()
    parser.description = (
        'Remove docker containers.'
    )
    parser.add_argument(
        '--list', '-l',
        help=(
            'List only. Do not delete containers.'
        ),
        action='store_true',
        dest='LIST_ONLY'
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
    args = parser.parse_args()

    filter_args = {
        'id': args.ID_FILTER,
        'name': args.NAME_FILTER,
        'status': args.STATUS_FILTER,
    }

    if args.LIST_ONLY:
        list_containers(filter_args=filter_args)
    else:
        list_cmd = list_containers(
            filter_args=filter_args,
            id_only=True,
            command_only=True
        )
        delete_containers(list_cmd=list_cmd)


if __name__ == '__main__':
    main()
