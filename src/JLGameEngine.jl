module JLGameEngine

using Dates
import GLFW
using ModernGL, GeometryTypes
using GLAbstraction

include("engine_types.jl")
include("engine_base.jl")
include("engine_shaders.jl")
include("engine_vertexdata.jl")
include("engine_basicentity.jl")

# Controller Input
include("engine_controllerinput.jl")

function CreateWindow(gfx::GfxState)::GfxState  
    window_hint = [ (GLFW.SAMPLES,      4),
                    (GLFW.DEPTH_BITS,   0),

                    (GLFW.ALPHA_BITS,   8),
                    (GLFW.RED_BITS,     8),
                    (GLFW.GREEN_BITS,   8),
                    (GLFW.BLUE_BITS,    8),
                    (GLFW.STENCIL_BITS, 0),
                    (GLFW.AUX_BUFFERS,  0),
                    (GLFW.CONTEXT_VERSION_MAJOR, 4),
                    (GLFW.CONTEXT_VERSION_MINOR, 5),
                    (GLFW.OPENGL_PROFILE, GLFW.OPENGL_ANY_PROFILE),
                    (GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE)]

    for (key, value) in window_hint
        GLFW.WindowHint(key, value)
    end 
    
    gfx.Window = GLFW.CreateWindow(gfx.WindowResolution[1], gfx.WindowResolution[2], "Window")
    GLFW.MakeContextCurrent(gfx.Window)
    GLFW.SetInputMode(gfx.Window, GLFW.STICKY_KEYS, GL_TRUE)
    
    return gfx
end

function InitGFX(res::Tuple{Int,Int})
    gfx = GfxState(-1, res, 
                       Dict{AbstractString, Shader}(), 
                       Dict{AbstractString, VertexData}())
    CreateWindow(gfx)
    return gfx
end

function InitialiseEngine(name::AbstractString, res::Tuple{Int,Int})
    gfx = InitGFX(res)
    eng = EngineState(  name, gfx, 
                        Dict{AbstractString,AbstractEntity}(),
                        -1,
                        0.0f0, 0.0f0,
                        0)
    return eng
end

end