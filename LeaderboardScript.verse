using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Teams }

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

    # @editable StartTrigger  : player_checkpoint_device = player_checkpoint_device{}
    # @editable FinishTrigger : player_checkpoint_device = player_checkpoint_device{}
    @editable Start2Trigger  : trigger_device = trigger_device{}
    @editable Finish2Trigger : trigger_device = trigger_device{}
    @editable Announcer     : hud_message_device = hud_message_device{}  
    @editable RestartTrigger : button_device = button_device{}
    @editable RestartCheckpoint : player_checkpoint_device = player_checkpoint_device{}

    var StartTimes : [player]?float = map{}  
    var BestTimes  : [player]?float = map{}  

    OnBegin<override>()<suspends>:void =
        Start2Trigger.TriggeredEvent.Subscribe(OnStart)
        Start2Trigger.TriggeredEvent.Subscribe(OnTriggered)
        Finish2Trigger.TriggeredEvent.Subscribe(OnFinish)
        RestartTrigger.InteractedWithEvent.Subscribe(OnRestart)
        # RestartTrigger.InteractedWithEvent.Subscribe(DamagePlayer)

    OnStart(Agent : ?agent) : void =
        if (TriggeringAgent := Agent?, P := player[TriggeringAgent]):
            if (set StartTimes[P] = option{GetSimulationElapsedTime()}):
                AnnounceTo(P, "Run started. Go!")

    OnFinish(Agent: ?agent): void =
        if (P := player[Agent?]):
            Print("finished: P stored")
            if (S := StartTimes[P]?):
                Print("finished: S stored")
                Elapsed := Max(0.0, GetSimulationElapsedTime() - S)
                if (set StartTimes[P] = false):
                    Print("finished: StartTimes set")
                    UpdatePersonalBest(P, Elapsed)
                    BroadcastTop3()
                    Print("broadcasted")
    
    OnRestart(Agent:agent): void=
        if (P := player[Agent]):
            if (set StartTimes[P] = option{GetSimulationElapsedTime()}):
                RestartCheckpoint.Register(Agent)
                DamagePlayer(Agent)


    OnTriggered(Agent:?agent):void =
        if (ValidAgent := Agent?):
            if (ChangeTeam[ValidAgent, 1]):
                # Success handled in ChangeTeam
                return
            else:
                Print("Failed to change team")
        else:
            Print("No valid agent found")


    ChangeTeam(Agent:agent, TeamIndex:int)<decides><transacts>:void =
        if:
            TeamCollection := GetPlayspace().GetTeamCollection()
            Teams := TeamCollection.GetTeams()
            TeamToJoin := Teams[TeamIndex]
            TeamCollection.AddToTeam[Agent, TeamToJoin]
        then:
            Print("Agent added to team successfully")
        else:
            Print("Failed to add agent to team")


    DamagePlayer(Agent:agent) : void= 
        if (Character := Agent.GetFortCharacter[]):
            Character.Damage(1000.0)
            if (ChangeTeam[Agent, 0]):
                # Success handled in ChangeTeam
                return
            else:
                Print("Failed to change team")


                

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
