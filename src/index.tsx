import {
  ButtonItem,
  definePlugin,
  Menu,
  MenuItem,
  PanelSection,
  PanelSectionRow,
  ServerAPI,
  showModal,
  staticClasses,
} from "decky-frontend-lib";
import { VFC } from "react";
import { FaShip } from "react-icons/fa";

import logo from "../assets/logo.png";

// interface AddMethodArgs {
//   left: number;
//   right: number;
// }

const Content: VFC<{ serverAPI: ServerAPI }> = ({}) => {
  // const [result, setResult] = useState<number | undefined>();

  // const onClick = async () => {
  //   const result = await serverAPI.callPluginMethod<AddMethodArgs, number>(
  //     "add",
  //     {
  //       left: 2,
  //       right: 2,
  //     }
  //   );
  //   if (result.success) {
  //     setResult(result.result);
  //   }
  // };

  return (
    <PanelSection title="Panel Section">
      <PanelSectionRow>
        <ButtonItem
          layout="below"
          onClick={(e) =>
            showModal(
              <Menu label="Menu" cancelText="CAAAANCEL" onCancel={() => {}}>
                <MenuItem onSelected={() => {}}>Item #1</MenuItem>
                <MenuItem onSelected={() => {}}>Item #2</MenuItem>
                <MenuItem onSelected={() => {}}>Item #3</MenuItem>
              </Menu>,
              e.currentTarget ?? window
            )
          }
        >
          Server says yolo
        </ButtonItem>
      </PanelSectionRow>

      <PanelSectionRow>
        <div style={{ display: "flex", justifyContent: "center" }}>
          <img src={logo} />
        </div>
      </PanelSectionRow>
    </PanelSection>
  );
};

export default definePlugin((serverApi: ServerAPI) => {
  return {
    title: () => <div className={staticClasses.Title}>Example Plugin</div>,
    content: () => <Content serverAPI={serverApi} />,
    icon: () => <FaShip />,
  };
});
