-- Swaps the object of an executor from one sequence to another.
-- Optionally, preserve the state/value of the sequence/fader after they are swapped.
-- When preserving the fader value, the outgoing sequence is stopped and
-- the incoming sequence takes on the running state of the previous sequence.
-- If the executor is not currently set to one of the passed sequences,
-- the results will not be predictable.
local json = require('json')
local function usage()
    Echo("Usage: call plugin <num> '{<json args>}'")
    Echo("       Where args are 'exec', 'seq1', 'seq2',")
    Echo("       'page'=1, 'preserve'=true")
    Echo("Example: call plugin 1 '{\"exec\": 106, \"seq1\": \"s1\", \"seq2\": \"s2\"}'")
end

local function getSeqByName(seqNameArg)
    local sequences = DataPool().Sequences
    for s = 1, #sequences do
        local sequence = sequences[s]
        if sequence ~= nil then
            if sequence['Name'] and sequence['Name'] ~= nil then
                if sequence['Name'] == seqNameArg then
                    return sequence
                end
            end
        end
    end
    return nil
end

local function main(handle, params)
    if params then
        local args = json.decode(params)
        if args["exec"] and args["seq1"] and args["seq2"] then
            local exec = args["exec"] - 100
            local seq1Name = args["seq1"]
            local seq2Name = args["seq2"]
            local page = 1
            local execObj
            local execObjName
            local origState
            local origVal
            local faderValue
            -- until proven otherwise:
            local newSeqName = seq1Name
            local newSeq = seq1
            local oldSeqName = seq2Name
            local oldSeq = seq2
            --

            if args["page"] then
                page = args["page"]
            end

            seq1 = getSeqByName(seq1Name)
            seq2 = getSeqByName(seq2Name)

            if seq1 == nil or seq2 == nil then
                Echo("ERROR: One or more sequence name not found in pool.")
                usage()
            else
                execObj = DataPool().Pages[page][exec]
                execObjName = execObj:Get("name")

                if execObjName == seq1Name then
                    -- proven otherwise!
                    newSeqName = seq2Name
                    newSeq = seq2
                    oldSeqName = seq1Name
                    oldSeq = seq1
                end

                if args["preserve"] ~= false then
                    origState = oldSeq:HasActivePlayback()
                    origVal = execObj:GetFader({})
                    faderValue = {}
                    faderValue.value = origVal
                end

                Cmd("assign sequence '" .. newSeqName .. "' at page " .. page .. "." .. exec + 100)

                if args["preserve"] ~= false then
                    execObj:SetFader(faderValue)

                    if origState then
                        Cmd("off sequence '" .. oldSeqName .. "'")
                        Cmd("on sequence '" .. newSeqName .. "'")
                    end
                end
            end

        else
            usage()
        end
    else
        usage()
    end
end
return main
