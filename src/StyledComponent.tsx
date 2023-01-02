import styled from "styled-components";

const Title = styled.h1`
  color: red;
  text-align: center;
`;

const Wrapper = styled.section`
  padding: 4em;
  background: papayawhip;
`;

export default () => (
  <Wrapper>
    <Title>This is a Styled Component!</Title>
  </Wrapper>
);
