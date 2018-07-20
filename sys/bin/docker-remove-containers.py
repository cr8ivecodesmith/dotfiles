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
        'action',
        help=(
            'Perform action [delete] or [list].'
        ),
    )
    parser.add_argument(
        '--id',
        help=(
            'Pass ID filter.'
        ),
        dest='ID_FILTER',
    )
    parser.add_argument(
        '--name',
        help=(
            'Pass Name filter.'
        ),
        dest='NAME_FILTER',
    )
    parser.add_argument(
        '--status',
        help=(
            'Pass Status filter.'
        ),
        dest='STATUS_FILTER',
    )
    args = parser.parse_args()

    filter_args = {
        'id': args.ID_FILTER,
        'name': args.NAME_FILTER,
        'status': args.STATUS_FILTER,
    }

    if args.action.strip().lower() == 'list':
        list_containers(filter_args=filter_args)
    elif args.action.strip().lower() == 'delete':
        list_cmd = list_containers(
            filter_args=filter_args,
            id_only=True,
            command_only=True
        )
        delete_containers(list_cmd=list_cmd)


if __name__ == '__main__':
    main()
