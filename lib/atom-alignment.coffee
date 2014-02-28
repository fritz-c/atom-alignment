Aligner = require './aligner'

matcher = [':', '=']

module.exports =
    activate: ->
        atom.workspaceView.command 'atom-alignment:align', '.editor', ->
            editor = atom.workspaceView.getActivePaneItem()
            alignLines editor


alignLines = (editor) ->

    alignableLines = Aligner.alignFor editor
    # If selected lines
    if alignableLines
        # For each range
        alignableLines.forEach (range) ->

            max = 0
            matched = null

            # Split lines
            textLines = editor.getTextInBufferRange(range).split("\n")

            # If we have more one line
            unless textLines.length < 2

                textLines.forEach (a, b) ->
                    # If no matcher has be set for the moment
                    # We try to take on
                    unless matched
                        matcher.forEach (possibleMatcher) ->
                            unless matched
                                if (a.indexOf possibleMatcher, 0) isnt -1
                                    matched = possibleMatcher

                    splitedString = a.split(matched)

                    if splitedString.length > 1
                        splitedString[0] = splitedString[0].replace(/\s+$/g, '')
                        # Detection of max in this range
                        max = if max < splitedString[0].length then splitedString[0].length else max

                if max and matched
                    # add space to better looking
                    max = max + 2

                    textLines.forEach (a, b) ->
                        splitedString = a.split(matched)
                        if splitedString.length > 1
                            # Remove un needed space
                            splitedString[0] = splitedString[0].replace(/\s+$/g, '')
                            diff = max - splitedString[0].length

                            if diff > 0
                                splitedString[0] = splitedString[0] + Array(diff).join(' ')

                            textLines[b] = splitedString.join(matched)

                    editor.setTextInBufferRange(range, textLines.join('\n'));
