local widget = require('widget')

local function handleCountdownTimer(event)
    print('timed out; timer:', event.source)
end

local countdownTimer

local function cancelTimer( event )
    print('cancelling timout, timer:', countdownTimer)
    timer.cancel(countdownTimer) 
end

local answerButton1 = widget.newButton
{
    onPress     = cancelTimer, 
    width = 100,
    height = 100,
    label = 'hello',
    emboss = true
}

countdownTimer = timer.performWithDelay(10000, handleCountdownTimer)
print('timer started:', countdownTimer)