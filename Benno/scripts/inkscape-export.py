#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
from pathlib import Path

import lxml.etree

INKSCAPE_NS = {
    "inkscape": "http://www.inkscape.org/namespaces/inkscape",
    "sodipodi": "http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
    "svg": "http://www.w3.org/2000/svg",
}


def main(args):
    doc = lxml.etree.parse(args.DOCUMENT)

    out_dir = Path(args.output_directory)
    out_dir.mkdir(parents=True, exist_ok=True)

    commands = []
    for e in doc.xpath(
        './/*[starts-with(@inkscape:label, "export-")]', namespaces=INKSCAPE_NS
    ):
        i = e.get("id")
        label = e.get(f"{{{INKSCAPE_NS['inkscape']}}}label")
        name = label[len("export-") :]
        out_filename = out_dir / (name + ".pdf")
        print(str(out_filename) + ":", args.DOCUMENT)

        commands += [
            f"select-by-id:{i}",
            "fit-canvas-to-selection",
            f"export-filename:{out_filename}",
            "export-do",
            "select-clear"
        ]

    script = ";".join(commands) + "\n"
    try:
        subprocess.check_output(["inkscape", "--shell", args.DOCUMENT], input=script.encode())
    except subprocess.CalledProcessError as e:
        print(e.output, file=sys.stderr)
        sys.exit(1)


def parse_args():
    parser = argparse.ArgumentParser(
        description="export all inkscape elements labelled as export-<NAME> to pdf"
    )
    parser.add_argument("DOCUMENT", help="inkscape document")
    parser.add_argument(
        "--output-directory",
        default=os.getcwd(),
        help="directory where the generated pdfs are placed (defaults to current working dir)",
    )
    return parser.parse_args()


if __name__ == "__main__":
    main(parse_args())
