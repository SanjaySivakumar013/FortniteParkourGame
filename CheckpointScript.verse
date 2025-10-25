using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }

IntsCategory<public><localizes>:message := "Integer Values"
Checkpoint<public><localizes>:message := "Player Checkpoints"

# A Verse-authored creative device that can be placed in a level
CheckpointScript := class(creative_device):

    #Checkpoint variables
    @editable:
        #The categories this editable belongs to.
        Categories := array{Checkpoint}
    playerCheckpoint1 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint2 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint3 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint4 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint5 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint6 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint7 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint8 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint9 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint10 :player_checkpoint_device = player_checkpoint_device{}

    @editable:
        Categories := array{Checkpoint}
    playerCheckpoint11 :player_checkpoint_device = player_checkpoint_device{}

    #Audio spawner variables 
    @editable
    audSpawner1 :audio_player_device = audio_player_device{}

    @editable
    audSpawner2 :audio_player_device = audio_player_device{}

    @editable
    audSpawner3 :audio_player_device = audio_player_device{}

    @editable
    audSpawner4 :audio_player_device = audio_player_device{}

    @editable
    audSpawner5 :audio_player_device = audio_player_device{}

    @editable
    audSpawner6 :audio_player_device = audio_player_device{}

    @editable
    audSpawner7 :audio_player_device = audio_player_device{}

    @editable
    audSpawner8 :audio_player_device = audio_player_device{}

    @editable
    audSpawner9 :audio_player_device = audio_player_device{}

    @editable
    audSpawner10 :audio_player_device = audio_player_device{}

    @editable
    audSpawner11 :audio_player_device = audio_player_device{}

    

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        playerCheckpoint1.FirstActivationPerAgentEvent.Subscribe(OnCheckpoint1Event)
        playerCheckpoint2.FirstActivationPerAgentEvent.Subscribe(OnCheckpoint2Event)
        playerCheckpoint3.FirstActivationPerAgentEvent.Subscribe(OnCheckpoint3Event)
        
        
    # Functions for playing audio when stepped on Checkpoint
    OnCheckpoint1Event(Agent:agent) :void=
        playerCheckpoint1.Register(Agent)
        audSpawner1.Play()
    OnCheckpoint2Event(Agent:agent) :void=
        playerCheckpoint2.Register(Agent)
        audSpawner2.Play()
    OnCheckpoint3Event(Agent:agent) :void=
        playerCheckpoint3.Register(Agent)
        audSpawner3.Play()
    OnCheckpoint4Event(Agent:agent) :void=
        playerCheckpoint4.Register(Agent)
        audSpawner4.Play()
    OnCheckpoint5Event(Agent:agent) :void=
        playerCheckpoint5.Register(Agent)
        audSpawner5.Play()
    OnCheckpoint6Event(Agent:agent) :void=
        playerCheckpoint6.Register(Agent)
        audSpawner6.Play()
    OnCheckpoint7Event(Agent:agent) :void=
        playerCheckpoint7.Register(Agent)
        audSpawner7.Play()
    OnCheckpoint8Event(Agent:agent) :void=
        playerCheckpoint8.Register(Agent)
        audSpawner8.Play()
    OnCheckpoint9Event(Agent:agent) :void=
        playerCheckpoint9.Register(Agent)
        audSpawner9.Play()
    OnCheckpoint10Event(Agent:agent) :void=
        playerCheckpoint10.Register(Agent)
        audSpawner10.Play()
    OnCheckpoint11Event(Agent:agent) :void=
        playerCheckpoint11.Register(Agent)
        audSpawner11.Play()
