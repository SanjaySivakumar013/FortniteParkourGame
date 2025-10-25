using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

RotationProps<public><localizes>:message := "Rotation Props"

rotation_tag := class(tag) {}
X := class(tag) {}
Y := class(tag) {}
Z := class(tag) {}

# A Verse-authored creative device that can be placed in a level
RotationScript := class(creative_device):
    
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        XObjectsList := FindCreativeObjectsWithTag(X{})
        YObjectsList := FindCreativeObjectsWithTag(Y{})
        ZObjectsList := FindCreativeObjectsWithTag(Z{})
        loop:
            tempint := 1
            block:
                for(XInst : XObjectsList):
                    if (Prop := creative_prop[XInst]):
                        spawn:
                            SmoothRotationPropYaw(Prop, 1.0)
                    else:
                        Print("X Prop is not a creative_prop")
            block:
                for(YInst:YObjectsList):
                    if (Prop := creative_prop[YInst]):
                        spawn:
                            SmoothRotationPropPitch(Prop, 1.0)
                    else:
                        Print("Y Prop is not a creative_prop")
            block:
                for(ZInst:ZObjectsList):
                    if (Prop := creative_prop[ZInst]):
                        spawn:
                            SmoothRotationPropRoll(Prop, 1.0)
                    else:
                        Print("Z Prop is not a creative_prop")
            if (tempint = 2):
                break
            Sleep(1.0)
    
    SmoothRotationPropYaw(Prop:creative_prop, speed:float)<suspends>:void=
        Transform_Prop := Prop.GetTransform()
        Translation_Prop := Transform_Prop.Translation
        Rotation_Prop := Transform_Prop.Rotation
        NewRotation := Rotation_Prop.ApplyYaw(180.0)
        MoveResult := Prop.MoveTo(Translation_Prop, NewRotation, speed)
    
    SmoothRotationPropPitch(Prop:creative_prop, speed:float)<suspends>:void=
        Transform_Prop := Prop.GetTransform()
        Translation_Prop := Transform_Prop.Translation
        Rotation_Prop := Transform_Prop.Rotation
        NewRotation := Rotation_Prop.ApplyYaw(180.0)
        MoveResult := Prop.MoveTo(Translation_Prop, NewRotation, speed)
    
    SmoothRotationPropRoll(Prop:creative_prop, speed:float)<suspends>:void=
        Transform_Prop := Prop.GetTransform()
        Translation_Prop := Transform_Prop.Translation
        Rotation_Prop := Transform_Prop.Rotation
        NewRotation := Rotation_Prop.ApplyYaw(180.0)
        MoveResult := Prop.MoveTo(Translation_Prop, NewRotation, speed)
    
