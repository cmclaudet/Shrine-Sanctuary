using System;
using System.Collections.Generic;
using Godot;
using Godot.Collections;

public partial class HandEquip : Sprite2D
{
    [Signal]
    public delegate void OnToolContactSignalEventHandler(Dictionary equippedItem);

    private EquipableItem _equippedItem;
    public EquipableItem EquippedItem
    {
        get { return _equippedItem; }
        set
        {
            _equippedItem = value;
            if (value != null)
            {
                this.Texture = value.icon;
            }
            else
            {
                this.Texture = null;
            }
        }
    }

    public void OnEquippedItemContact()
    {
        if (!Engine.IsEditorHint())
        {
            var equippedItemDict = new Dictionary { {"value", _equippedItem} };
            EmitSignal(SignalName.OnToolContactSignal, equippedItemDict);
        }
    }
}

public partial class EquipableItem : Item
{
    internal Texture2D icon;
}

public partial class Item : Resource {}