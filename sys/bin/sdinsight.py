#!/usr/bin/env python
"""
Read SD Card Information

Helps with checking counterfeit cards.

References:

- https://www.cameramemoryspeed.com/sd-memory-card-faq/reading-sd-card-cid-serial-psn-internal-numbers/
- https://blog.mdb977.de/read-sd-card-serial-number-from-cid/
- https://goughlui.com/2014/01/02/project-read-collect-decode-sd-card-cid-register-data/

"""  # noqa

from pathlib import Path

DEFAULT_PATH = Path('/sys/block/mmcblk0/device/')


def main(device_path=None):
    device_path = Path(device_path or DEFAULT_PATH)
    assert device_path.exists()

    print(f'Reading SD Info in {device_path}')
    print('-' * 5)
    for f in (i for i in device_path.glob('*') if i.is_file()):
        data = f.open().read().strip()
        print(f'{f.name} \t-> {data}')


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--device-path', help='Set device path.')

    args = parser.parse_args()

    main(args.device_path)
