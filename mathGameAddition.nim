import std/[random, times, terminal, strutils]

type
  Equation = tuple
    a: int
    b: int

proc initMult(): seq[Equation] =
  for n1 in 0..10:
    for n2 in 0..10:
      result.add (n1, n2)

proc exit(input: string): bool =
  if input != "q": return false
  return true

proc restart(input: string): bool =
  if input != "r": return false
  return true

proc hint(input: string): bool =
  if input != "h": return false
  return true

proc detailedTime(seconds: float): string =
  result &= $(seconds / 60.0).toInt
  result &= " minutes "
  result &= $(seconds.toInt mod 60)
  result &= " seconds.  "

proc squareBracket(input: string): string =
  result = "[" & input & "]"

template resetVariables() =
  remainingQuestions = initMult()
  input = 0
  errorCount = 0
  start = cpuTime()

template processInput() =
  inputString = readLine(stdin)
  try:
    input = inputString.parseInt
  except:
    if inputString.exit: break
    if inputString.restart: resetVariables()

proc main() =
  var
    remainingQuestions = initMult()
    input: int
    start = cpuTime()
    errorCount: int
    inputString: string
  let
    wrongAnswer = "That was not correct. Type 'h' for a hint."
    win = "You have Completed all Additions from 0 to 10.  GREAT JOB!"

  randomize()
  while true:
    eraseScreen()
    setCursorPos(0, 0)

    let idx = rand(0..remainingQuestions.len - 1)
    styledEcho styleBright, styleUnderscore, fgYellow,
        $remainingQuestions[idx].a & " + " & $remainingQuestions[idx].b
    processInput()
    if inputString.restart: continue

    # Ask again
    while input != remainingQuestions[idx].a + remainingQuestions[idx].b:
      if inputString.hint:
        styledEcho styleBright, fgCyan, squareBracket(
            $(remainingQuestions[idx].a + remainingQuestions[idx].b))
      else: styledEcho styleBright, fgRed, wrongAnswer
      errorCount += 1
      processInput()
      if inputString.exit: break
      if inputString.restart: break
    if inputString.exit: break
    if inputString.restart: continue

    # Carry On
    if remainingQuestions.len > 0:
      remainingQuestions.delete(idx)

    # Win Condition
    if remainingQuestions.len == 0:
      styledEcho styleBright, fgGreen, win
      styledEcho styleBright, fgGreen,
          "Task Completed in " & detailedTime(cpuTime() - start) &
          "Errors:  " & $errorCount
      inputString = readLine(stdin)
      if inputString.exit: break
      resetVariables()

main()



