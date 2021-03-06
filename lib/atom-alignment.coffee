Aligner = require './aligner'

module.exports =
    config:
        alignBy:
            type: 'array'
            default: ['=>', ':=', ':', '=']
            items:
                type: "string"
            description: "consider the order, the left most matching separator is taken to compute the alignment"
            order: 1
        leftSpaceChars:
            type: 'array'
            default: ['=>', ':=', '=']
            items:
                type: "string"
            description: "insert space left of the separator (a=1 > a =1)"
            order: 2
        rightSpaceChars:
            type: 'array'
            default: ['=>', ':=', '=', ":"]
            items:
                type: "string"
            description: "insert space right of the separator (a=1 > a= 1)"
            order: 3
        ignoreChars:
            type: 'array'
            default: ['===', '!==', '==', '!=', '>=', '<=', '::']
            items:
                type: "string"
            description: "ignore as separator"
            order: 4

    activate: (state) ->
        atom.commands.add 'atom-workspace',
            'atom-alignment:align': ->
                alignLines false

            'atom-alignment:alignMultiple': ->
                alignLines true

alignLines = (multiple) ->
    editor          = atom.workspace.getActiveTextEditor()
    leftSpaceChars  = atom.config.get 'atom-alignment.leftSpaceChars'
    rightSpaceChars = atom.config.get 'atom-alignment.rightSpaceChars'
    matcher         = atom.config.get 'atom-alignment.alignBy'
    ignoreChars     = atom.config.get 'atom-alignment.ignoreChars'
    aligner         = new Aligner(editor, leftSpaceChars, rightSpaceChars, matcher, ignoreChars)
    aligner.align(multiple)
    return
