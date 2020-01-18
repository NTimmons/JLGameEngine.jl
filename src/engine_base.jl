function ShutdownEngine(eng)
    
    try
        println("Shutting down Engine: $(eng.Name)")
        GLFW.DestroyWindow(eng.Gfx.Window);
    catch
        return false
    end

    #TODO: Clear out entities and GFX state
    return true;
end

function RenderCurrentState(eng)
    # Loop all entities and submit for rendering
    # TODO: Do some nice batching so we dont flood draw calls...
    for ent in eng.Entities
        RenderEntity(eng, ent[2], eng.KeyState) 
    end  
end

function RegisterEntity(eng, name::AbstractString, ent::AbstractEntity)
    eng.Entities[name] = ent
end

function RenderEntity(eng, ent::AbstractEntity, KeyState)
    println("RenderEntity(::AbstractEntity): Nothing implemented for $(typeof(ent)).") 
end

function UpdateEntities(eng)
    for ent in eng.Entities
        UpdateEntity(eng, ent[2], eng.KeyState) 
    end  
end

function UpdateEntity(eng, ent::AbstractEntity, KeyState)
    println("UpdateEntity(::AbstractEntity): Nothing implemented for $(typeof(ent)).") 
end

function MainEngineLoop(eng)
    
    InitialiseControllerInput()
    BeginControllerInput()
    
    startTime       = Dates.now()
    eng.TimeCurrent = Dates.Period(startTime - Dates.now()).value/1000.0
    eng.FrameCount  = 0
    
    while !GLFW.WindowShouldClose(eng.Gfx.Window)
        glClearColor(0,0,0,0)
        glClear(GL_COLOR_BUFFER_BIT) 
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        
        # Handle Inputs
        eng.KeyState = GetControllerState(0)
        
        # Get Time
        newFrameTime    = Dates.Period(startTime - Dates.now()).value/1000.0
        eng.TimeDelta   = eng.TimeCurrent - newFrameTime
        eng.TimeCurrent = newFrameTime
        
        # Update Entities
        UpdateEntities(eng)
        
        # Render Current State
        RenderCurrentState(eng)
        
        GLFW.SwapBuffers(eng.Gfx.Window)
        GLFW.PollEvents()
    end
    
    ShutdownEngine(eng)
end