<?php

namespace App\Http\Api\V1;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator as FacadesValidator;

class LoginController
{
    public function login(Request $request)
    {
        try {
            $input = $request->all();

            $validator = FacadesValidator::make($input, [
                "login" => 'required|string', // Champ unique pour email ou username
                "password" => 'required|string',
            ]);
            
            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Erreur de Validation',
                    'errors' => $validator->errors(),
                ], 422);
            }

            // Déterminer si le login est un email ou un username
            $loginType = filter_var($request->login, FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
            
            // Créer les credentials en fonction du type
            $credentials = [
                $loginType => $request->login,
                'password' => $request->password
            ];

            if (!Auth::guard('web')->attempt($credentials)) {
                return response()->json([
                    'status' => false,
                    'message' => 'Identifiants incorrects',
                    'errors' => ['login' => ['Email/Username ou mot de passe incorrect']],
                ], 401);
            }
            
            $user = User::where($loginType, $request->login)->first();

            unset($user->password);

            return response()->json([
                'status' => true,
                'message' => 'Connexion réussie !',
                "token" => $user->createToken('auth_user')->plainTextToken,
                "token_type" => "Bearer",
                "user" => UserResource::make($user),
            ]);

        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => $th->getMessage(),
            ], 500);
        }
    }
     
    public function register(Request $request){
        try {
    
            $input = $request->all();
    
            $validator = FacadesValidator::make($input, [
                "firstName"=> 'required|string|max:255',
                "lastName"=> 'required|string|max:255',
                "email"=> 'required|string|max:255|email|unique:users',
                "password"=> 'required|string',
            ]);
            
            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Erreur de Validation',
                    'errors' => $validator->errors(),
                ], 422);
            }
    
            $input['password'] = Hash::make($request->password);
            
            $user = User::create($input);
    
            return response()->json([
                'status' => true,
                'message' => 'Utilisateur créer avec succèe',
                "token"=> $user->createToken('auth_user')->plainTextToken,
                "token_type"=> "Bearer",
                "user"=> UserResource::make($user),
            ]);
    
        } catch (\Throwable $th) {
    
            return response()->json([
                'status' => false,
                'message' => $th->getMessage(),
            ], 500);
        }
 
    }

    public function logout(Request $request){
          
        $request->user()->tokens()->delete();

        return response()->json([
            'status' => true,
            'message' => 'Vous êtes déconnecter !',
            
        ]);
    }
}