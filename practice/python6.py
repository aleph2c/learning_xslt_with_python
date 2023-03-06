import pprint
def pp(item):
    pprint(pprint(item)

root = {
    "root": {
        "meta": {
            "@selection" :"item[@name='Pink']/item[@name='Young']/item[@name='Murphy']",
        },
        "data": {
            "items": {
                "item": {
                    "@name" :"Pink",
                    "item": {
                        "@name" :"Young",
                        "item": {
                            "@name" :"Murphy",
                        },
                    },
                },
                "item": {
                    "@name" :"Pink",
                    "item": {
                        "@name" :"Young",
                        "item": {
                            "@name" :"Rex",
                        },
                    },
                },
                "item": {
                    "@name" :"Green",
                    "item": {
                        "@name" :"Young",
                        "item": {
                            "@name" :"Vinny",
                        },
                    },
                },
            },
        },
    },
}

if __name__ == '__main__':
    pp(root)