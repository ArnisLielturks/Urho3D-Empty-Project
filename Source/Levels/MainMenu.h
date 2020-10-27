#pragma once

#include <Urho3D/UI/Button.h>
#include "../BaseLevel.h"
#include <vector>

using namespace Urho3D;

namespace Levels {

    class MainMenu : public BaseLevel
    {
    URHO3D_OBJECT(MainMenu, BaseLevel);

    public:
        MainMenu(Context* context);
        ~MainMenu();
        static void RegisterObject(Context* context);

    protected:
        void Init () override;

    private:
        void CreateScene();

        void CreateUI();

        void SubscribeToEvents();

        void AddButton(const String& buttonName, const String& label, const String& name, const StringHash& eventToCall);

        void HandleUpdate(StringHash eventType, VariantMap& eventData);

        void InitCamera();

        SharedPtr<Node> cameraRotateNode_;
        SharedPtr<UIElement> buttonsContainer_;
        List<SharedPtr<Button>> dynamicButtons_;

        Button* CreateButton(const String& text);
    };
}
