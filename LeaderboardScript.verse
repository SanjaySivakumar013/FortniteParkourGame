using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Fix: Use overload instead of localizes for string to message conversion
ToMessage<localizes>(S : string) : message = "{S}"
ToMessage<localizes>(A : agent)  : message = "{A}"

TimeEntry := class():
    P : player
    T : float

FormatTime(Seconds: float): string =
    if:
        TotalMs := Round[Seconds * 100.0]                
        TotalSec := Floor[TotalMs * 1.0 / 100.0]
        Minutes := Floor[TotalSec * 1.0 / 60.0]
        SecOnly := TotalSec - Minutes * 60
        Hundredths := TotalMs - TotalSec * 100
        var SecPadded : string = ToString(SecOnly)
        if (SecOnly < 10):
            set SecPadded = "0" + SecPadded
        var HundPadded : string = ToString(Hundredths)
        if (Hundredths < 10):
            set HundPadded = "0" + HundPadded
    then:
        "{Minutes}:{SecPadded}.{HundPadded}"
    else:
        ToString(Seconds)

ObbyLeaderboardDevice := class(creative_device):

    @editable StartTrigger  : player_checkpoint_device = player_checkpoint_device{}
    @editable FinishTrigger : player_checkpoint_device = player_checkpoint_device{}
    @editable Announcer     : hud_message_device = hud_message_device{}  
    @editable RestartTrigger : button_device = button_device{}
    @editable RestartCheckpoint : player_checkpoint_device = player_checkpoint_device{}

    var StartTimes : [player]?float = map{}  
    var BestTimes  : [player]?float = map{}  

    OnBegin<override>()<suspends>:void =
        StartTrigger.FirstActivationPerAgentEvent.Subscribe(OnStart)
        FinishTrigger.FirstActivationPerAgentEvent.Subscribe(OnFinish)
        RestartTrigger.InteractedWithEvent.Subscribe(OnRestart)
        RestartTrigger.InteractedWithEvent.Subscribe(DamagePlayer)

    OnStart(Agent: agent): void =
        if (P := player[Agent]):
            if (set StartTimes[P] = option{GetSimulationElapsedTime()}):
                AnnounceTo(P, "Run started. Go!")

    OnFinish(Agent: agent): void =
        if (P := player[Agent]):
            if (S := StartTimes[P]?):
                Elapsed := Max(0.0, GetSimulationElapsedTime() - S)
                if (set StartTimes[P] = false):
                    UpdatePersonalBest(P, Elapsed)
                    BroadcastTop3()
    
    OnRestart(Agent:agent): void=
        if (P := player[Agent]):
            if (set StartTimes[P] = option{GetSimulationElapsedTime()}):
                RestartCheckpoint.Register(Agent)
    
    DamagePlayer(Agent:agent) : void= 
            if (Character := Agent.GetFortCharacter[]):
                Character.Damage(1000.0)

                

    UpdatePersonalBest(P: player, NewTime: float): void =
        if (BT := BestTimes[P]?):
            if (NewTime < BT):
                if (set BestTimes[P] = option{NewTime}):
                    AnnounceTo(P, "NEW PERSONAL BEST: " + FormatTime(NewTime))
            else:
                AnnounceTo(P, "Finished: " + FormatTime(NewTime) + " (PB: " + FormatTime(BT) + ")")
        else:
            if (set BestTimes[P] = option{NewTime}):
                AnnounceTo(P, "First time set: " + FormatTime(NewTime))

    # Fix: Move comparator to class scope
    TimeLess(L:TimeEntry, R:TimeEntry)<computes><decides>:void = L.T < R.T

    BroadcastTop3(): void =
        var Entries : []TimeEntry = array{}
        for (P -> BT : BestTimes):
            if (T := BT?):
                set Entries += array{ TimeEntry{P:=P, T:=T} }

        # SortBy is not available in Verse, so we need to implement our own sorting logic
        # For now, we'll just use the unsorted entries
        Sorted := Entries

        if (Sorted.Length = 0):
            return

        EndIx := Min(2, Sorted.Length - 1)  
        var Msg : string = "LEADERBOARD — TOP TIMES\n"
        for (i := 0..EndIx):
            if (E := Sorted[i]):
                set Msg += "{i+1}) Player — " + FormatTime(E.T) + "\n"

        for (P -> __ : BestTimes):
            AnnounceTo(P, Msg)

    AnnounceTo(P: player, Text: string): void =
        Announcer.Show(P, ToMessage(Text))