module Main exposing (..)

import Html exposing (Html, text, program, div, button, br, input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, field, string, int, float, maybe, succeed)
import Json.Decode.Extra exposing ((|:))
import Json.Encode as Encode exposing (encode, object, string, int)


main =
    program
        { init = model
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }



{-
   Types
-}


type alias SimpleUser =
    { firstName : String
    , lastName : String
    , age : Int
    }


type alias MediumUser =
    { firstName : String
    , lastName : String
    , age : Int
    , height : Float
    , girth : Float
    , description : Maybe String
    }


type alias Model =
    { simpleUser : SimpleUser
    , simpleUserToSend : SimpleUser
    , mediumUser : MediumUser
    }


type Msg
    = GetSimpleUser
    | FetchedSimpleUser (Result Http.Error SimpleUser)
    | SendSimpleUser
    | GetMediumUser
    | FetchedMediumUser (Result Http.Error MediumUser)
    | SentSimpleUser (Result Http.Error SimpleUser)
    | SimpleUserChanged SimpleUser


type FieldType
    = FirstName
    | LastName
    | Age



{-
   Init functions
-}


initSimpleUser : SimpleUser
initSimpleUser =
    SimpleUser "" "" 0


initMediumUser : MediumUser
initMediumUser =
    MediumUser "" "" 0 0.0 0.0 Nothing


model : ( Model, Cmd Msg )
model =
    ( Model initSimpleUser initSimpleUser initMediumUser, Cmd.none )



{-
   Update
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetSimpleUser ->
            ( model, getSimpleUser )

        SendSimpleUser ->
            ( model, postSimpleUser model.simpleUserToSend )

        FetchedSimpleUser (Ok simpleUser) ->
            ( { model | simpleUser = simpleUser }, Cmd.none )

        FetchedSimpleUser (Err _) ->
            ( model, Cmd.none )

        GetMediumUser ->
            ( model, getMediumUser )

        FetchedMediumUser (Ok mediumUser) ->
            ( { model | mediumUser = mediumUser }, Cmd.none )

        FetchedMediumUser (Err _) ->
            ( model, Cmd.none )

        SentSimpleUser (Ok simpleUser) ->
            ( { model | simpleUser = simpleUser }, Cmd.none )

        SentSimpleUser (Err _) ->
            ( model, Cmd.none )

        SimpleUserChanged simpleUserToSend ->
            ( { model | simpleUserToSend = simpleUserToSend }, Cmd.none )



{-
   Requests
-}


getSimpleUser : Cmd Msg
getSimpleUser =
    makeRequest FetchedSimpleUser (Http.get "/simple-user" simpleUserDecoder)


getMediumUser : Cmd Msg
getMediumUser =
    makeRequest FetchedMediumUser (Http.get "/medium-user" mediumUserDecoder)


postSimpleUser : SimpleUser -> Cmd Msg
postSimpleUser simpleUser =
    makeRequest SentSimpleUser (Http.post "/simple-user" (Http.jsonBody <| simpleUserEncoder simpleUser) simpleUserDecoder)


makeRequest : (Result Http.Error a -> Msg) -> Http.Request a -> Cmd Msg
makeRequest responseMsg request =
    Http.send responseMsg request



{-
   Encoders
-}


simpleUserEncoder simpleUser =
    object
        [ ( "firstName", Encode.string simpleUser.firstName )
        , ( "lastName", Encode.string simpleUser.lastName )
        , ( "age", Encode.int simpleUser.age )
        ]



{-
   Decoders
-}


simpleUserDecoder : Decoder SimpleUser
simpleUserDecoder =
    succeed SimpleUser
        |: (field "firstName" Decode.string)
        |: (field "lastName" Decode.string)
        |: (field "age" Decode.int)


mediumUserDecoder : Decoder MediumUser
mediumUserDecoder =
-- fill in decoder body


{-
   Simple user form update
-}


updateSimpleUser simpleUserToSend fieldType val =
    case fieldType of
        FirstName ->
            SimpleUserChanged { simpleUserToSend | firstName = val }

        LastName ->
            SimpleUserChanged { simpleUserToSend | lastName = val }

        Age ->
            SimpleUserChanged { simpleUserToSend | age = Result.withDefault 0 (String.toInt val) }



{-
   Simple user form
-}


simpleUserForm simpleUser =
    div []
        [ input [ placeholder "First name", onInput <| updateSimpleUser simpleUser FirstName ] []
        , input [ placeholder "Last name", onInput <| updateSimpleUser simpleUser LastName ] []
        , input [ placeholder "Age", onInput <| updateSimpleUser simpleUser Age ] []
        , button [ onClick SendSimpleUser ] [ text "Send simple user" ]
        ]



{-
   View
-}


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ text ("Simple user: " ++ (toString model.simpleUser))
            , br [] []
            , button [ onClick GetSimpleUser ] [ text "Get and decode simple user" ]
            , br [] []
            , simpleUserForm model.simpleUserToSend
            ]
        , br [] []
        , div []
            [ text ("Medium user: " ++ (toString model.mediumUser))
            , br [] []
            , button [ onClick GetMediumUser ] [ text "Get and decode medium user" ]
            ]
        ]
