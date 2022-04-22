import {
  Button,
  definePlugin,
  PanelSection,
  PanelSectionRow,
  ServerAPI,
  TabTitle,
} from "decky-frontend-lib";
import { useState, VFC } from "react";
import { FaShip } from "react-icons/fa";

interface AddMethodArgs {
  left: number;
  right: number;
}

const Content: VFC<{ serverAPI: ServerAPI }> = ({ serverAPI }) => {
  const [result, setResult] = useState<number | undefined>();

  const onClick = async () => {
    const result = await serverAPI.callPluginMethod<AddMethodArgs, number>(
      "add",
      {
        left: 2,
        right: 2,
      }
    );
    if (result.success) {
      setResult(result.result);
    }
  };

  return (
    <PanelSection>
      <PanelSectionRow>
        <Button layout="below" bottomSeparator={false} onClick={onClick}>
          What is 2+2?
        </Button>
        <div>Server says: {result}</div>
      </PanelSectionRow>
    </PanelSection>
  );
};

export default definePlugin((serverApi) => {
  return {
    title: <TabTitle>Example Plugin</TabTitle>,
    content: <Content serverAPI={serverApi} />,
    icon: <FaShip />,
  };
});
